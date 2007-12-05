Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbXLETlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbXLETlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXLETig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:38:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbXLETie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:38:34 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/28] Permit filesystem local caching [try #2]
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 05 Dec 2007 19:38:18 +0000
Message-ID: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



These patches add local caching for network filesystems such as NFS and AFS.

The patches can roughly be broken down into a number of sets:

  (*) 01-keys-inc-payload.diff
  (*) 02-keys-search-keyring.diff
  (*) 03-keys-callout-blob.diff

      Three patches to the keyring code made to help the CIFS people.
      Included because of patches 05-08.

  (*) 04-keys-get-label.diff

      A patch to allow the security label of a key to be retrieved.
      Included because of patches 05-08.

  (*) 05-security-current-fsugid.diff
  (*) 06-security-separate-task-bits.diff
  (*) 07-security-subjective.diff
  (*) 08-security-kernel-service.diff

      Patches to permit the subjective security of a task to be overridden.
      All the security details in task_struct are decanted into a new struct
      that task_struct then has two pointers two: one that defines the
      objective security of that task (how other tasks may affect it) and one
      that defines the subjective security (how it may affect other objects).

      Note that I have dropped the idea of struct cred for the moment.  With
      the amount of stuff that was excluded from it, it wasn't actually any
      use to me.  However, it can be added later.

      Required for cachefiles.

  (*) 09-release-page.diff
  (*) 10-fscache-page-flags.diff
  (*) 11-add_wait_queue_tail.diff
  (*) 12-fscache.diff

      Patches to provide a local caching facility for network filesystems.

  (*) 13-cachefiles-ia64.diff
  (*) 14-cachefiles-ext3-f_mapping.diff
  (*) 15-cachefiles-write.diff
  (*) 16-cachefiles-monitor.diff
  (*) 17-cachefiles-export.diff
  (*) 18-cachefiles.diff

      Patches to provide a local cache in a directory of an already mounted
      filesystem.

  (*) 19-fscache-nfs.diff
  (*) 20-fscache-nfs-mount.diff
  (*) 21-fscache-nfs-display.diff

      Patches to provide NFS with local caching.

  (*) 22-fcrypt-bit-annotate.diff

      A fix for AFS.

  (*) 23-afs-testsetpageerror.diff
  (*) 24-afs-cancel_rejected_write.diff
  (*) 25-afs-rejected-writeback.diff
  (*) 26-afs-opID.diff
  (*) 27-afs-shared-writable-mmap.diff

      Patches to provide AFS with improved write support.

  (*) 28-fscache-afs.diff

      Patches to provide AFS with local caching.

There are some issues with these patches that I'd like advice on:

 (1) Is the security override stuff acceptable?

 (2) Should the audit context be placed in the task_security struct?

 (3) Should the task security context actually be shared by CLONE_THREAD?
     (should it be placed in struct thread_group_security).

 (4) How to handle superblock sharing in NFS?  (I've sent a separate email on
     this)

Andrew, Linus, can you please hold off on taking these patches for the moment.


--
A tarball of the patches is available at:

	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-25.tar.bz2


To use this version of CacheFiles, the cachefilesd-0.9 is also required.  It
is available as an SRPM:

	http://people.redhat.com/~dhowells/fscache/cachefilesd-0.9-1.fc7.src.rpm

Or as individual bits:

	http://people.redhat.com/~dhowells/fscache/cachefilesd-0.9.tar.bz2
	http://people.redhat.com/~dhowells/fscache/cachefilesd.fc
	http://people.redhat.com/~dhowells/fscache/cachefilesd.if
	http://people.redhat.com/~dhowells/fscache/cachefilesd.te
	http://people.redhat.com/~dhowells/fscache/cachefilesd.spec

The .fc, .if and .te files are for manipulating SELinux.

David
