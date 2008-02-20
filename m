Return-Path: <linux-kernel-owner+w=401wt.eu-S1763449AbYBTQH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763449AbYBTQH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYBTQHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:07:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbYBTQHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:07:11 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/37] Permit filesystem local caching
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:05:58 +0000
Message-ID: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
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
  (*) 08-security-kernel_service-class.diff
  (*) 09-security-kernel-service.diff
  (*) 10-security-nfsd.diff

      Patches to permit the subjective security of a task to be overridden.
      All the security details in task_struct are decanted into a new struct
      that task_struct then has two pointers two: one that defines the
      objective security of that task (how other tasks may affect it) and one
      that defines the subjective security (how it may affect other objects).

      Note that I have dropped the idea of struct cred for the moment.  With
      the amount of stuff that was excluded from it, it wasn't actually any
      use to me.  However, it can be added later.

      Required for cachefiles.

  (*) 11-release-page.diff
  (*) 12-fscache-page-flags.diff
  (*) 13-add_wait_queue_tail.diff
  (*) 14-fscache.diff

      Patches to provide a local caching facility for network filesystems.

  (*) 15-cachefiles-ia64.diff
  (*) 16-cachefiles-ext3-f_mapping.diff
  (*) 17-cachefiles-write.diff
  (*) 18-cachefiles-monitor.diff
  (*) 19-cachefiles-export.diff
  (*) 20-cachefiles.diff

      Patches to provide a local cache in a directory of an already mounted
      filesystem.

  (*) 21-nfs-comment.diff
  (*) 22-nfs-fscache-option.diff
  (*) 23-nfs-fscache-kconfig.diff
  (*) 24-nfs-fscache-top-index.diff
  (*) 25-nfs-fscache-server-obj.diff
  (*) 26-nfs-fscache-super-obj.diff
  (*) 27-nfs-fscache-inode-obj.diff
  (*) 28-nfs-fscache-use-inode.diff
  (*) 29-nfs-fscache-invalidate-pages.diff
  (*) 30-nfs-fscache-iostats.diff
  (*) 31-nfs-fscache-page-management.diff
  (*) 32-nfs-fscache-read-context.diff
  (*) 33-nfs-fscache-read-fallback.diff
  (*) 34-nfs-fscache-read-from-cache.diff
  (*) 35-nfs-fscache-store-to-cache.diff
  (*) 36-nfs-fscache-mount.diff
  (*) 37-nfs-fscache-display.diff

      Patches to provide NFS with local caching.

      A couple of questions on the NFS iostat changes: (1) Should I update the
      iostat version number; (2) is it permitted to have conditional iostats?


I've brought the patchset up to date with respect to the 2.6.25-rc1 merge
window, in particular altering Smack to handle the split in objective and
subjective security in the task_struct.

--
A tarball of the patches is available at:

	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-30.tar.bz2


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
