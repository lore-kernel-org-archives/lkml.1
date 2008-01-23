Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYAWRVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYAWRVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYAWRVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:21:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbYAWRVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:21:01 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/27] Permit filesystem local caching [try #2]
To: Trond.Myklebust@netapp.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 23 Jan 2008 17:20:39 +0000
Message-ID: <20080123172038.11107.86025.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



These patches add local caching for network filesystems such as NFS.

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
  (*) 08-security-secctx2secid.diff
  (*) 09-security-additional-classes.diff
  (*) 10-security-kernel_service-class.diff
  (*) 11-security-kernel-service.diff
  (*) 12-security-nfsd.diff

      Patches to permit the subjective security of a task to be overridden.
      All the security details in task_struct are decanted into a new struct
      that task_struct then has two pointers two: one that defines the
      objective security of that task (how other tasks may affect it) and one
      that defines the subjective security (how it may affect other objects).

      Note that I have dropped the idea of struct cred for the moment.  With
      the amount of stuff that was excluded from it, it wasn't actually any
      use to me.  However, it can be added later.

      Required for cachefiles.

  (*) 13-release-page.diff
  (*) 14-fscache-page-flags.diff
  (*) 15-add_wait_queue_tail.diff
  (*) 16-fscache.diff

      Patches to provide a local caching facility for network filesystems.

  (*) 17-cachefiles-ia64.diff
  (*) 18-cachefiles-ext3-f_mapping.diff
  (*) 19-cachefiles-write.diff
  (*) 20-cachefiles-monitor.diff
  (*) 21-cachefiles-export.diff
  (*) 22-cachefiles.diff

      Patches to provide a local cache in a directory of an already mounted
      filesystem.

  (*) 23-nfs-memleak.diff
  (*) 24-fscache-nfs.diff
  (*) 25-fscache-nfs-mount.diff
  (*) 26-fscache-nfs-display.diff
  (*) 27-fscache-nfs-persb.diff

      Patches to provide NFS with local caching.  The fifth of these patches
      makes caching configurable per superblock.


I've fixed some current->fs[ug]id conversions as pointed out by Jan Harkes.

I also fixed patch 14 (fscache-page-flags.diff) to make
wait_on_page_owner_priv_2() use PG_owner_priv_2 rather than PG_private_2.

--
A tarball of the patches is available at:

	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-28.tar.bz2


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
