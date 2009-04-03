Return-Path: <linux-kernel-owner+w=401wt.eu-S936617AbZDCQQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936617AbZDCQQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935293AbZDCP7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:59:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56760 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935265AbZDCP7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:59:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org, trond.myklebust@fys.uio.no
cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] FS-Cache and CacheFiles with AFS and NFS support
Date: Fri, 03 Apr 2009 16:59:11 +0100
Message-ID: <29650.1238774351@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8fe74cf053de7ad2124a894996f84fa890a81093:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-fscache.git master

David Howells (41):
      Create a dynamically sized pool of threads for doing very slow work items
      Make slow-work thread pool actually dynamic
      Make the slow work pool configurable
      Document the slow work thread pool
      FS-Cache: Release page->private after failed readahead
      FS-Cache: Recruit a page flags for cache management
      FS-Cache: Add the FS-Cache netfs API and documentation
      FS-Cache: Add the FS-Cache cache backend API and documentation
      FS-Cache: Add main configuration option, module entry points and debugging
      FS-Cache: Add use of /proc and presentation of statistics
      FS-Cache: Root index definition
      FS-Cache: Add cache tag handling
      FS-Cache: Add cache management
      FS-Cache: Provide a slab for cookie allocation
      FS-Cache: Add netfs registration
      FS-Cache: Bit waiting helpers
      FS-Cache: Object management state machine
      FS-Cache: Implement the cookie management part of the netfs API
      FS-Cache: Add and document asynchronous operation handling
      FS-Cache: Implement data I/O part of netfs API
      CacheFiles: Permit the page lock state to be monitored
      CacheFiles: Export things for CacheFiles
      CacheFiles: A cache that backs onto a mounted filesystem
      FS-Cache: Make kAFS use FS-Cache
      NFS: Add comment banners to some NFS functions
      NFS: Add FS-Cache option bit and debug bit
      NFS: Permit local filesystem caching to be enabled for NFS
      NFS: Register NFS for caching and retrieve the top-level index
      NFS: Define and create server-level objects
      NFS: Define and create superblock-level objects
      NFS: Define and create inode-level cache objects
      NFS: Use local disk inode cache
      NFS: Invalidate FsCache page flags when cache removed
      NFS: Add some new I/O counters for FS-Cache doing things for NFS
      NFS: FS-Cache page management
      NFS: Add read context retention for FS-Cache to call back with
      NFS: nfs_readpage_async() needs to be accessible as a fallback for local caching
      NFS: Read pages from FS-Cache into an NFS inode
      NFS: Store pages from an NFS inode into a local cache
      NFS: Display local caching state
      NFS: Add mount options to enable local caching on NFS

 Documentation/filesystems/caching/backend-api.txt |  658 +++++++++++++++
 Documentation/filesystems/caching/cachefiles.txt  |  501 ++++++++++++
 Documentation/filesystems/caching/fscache.txt     |  333 ++++++++
 Documentation/filesystems/caching/netfs-api.txt   |  778 ++++++++++++++++++
 Documentation/filesystems/caching/object.txt      |  313 ++++++++
 Documentation/filesystems/caching/operations.txt  |  213 +++++
 Documentation/slow-work.txt                       |  174 ++++
 fs/Kconfig                                        |    7 +
 fs/Makefile                                       |    2 +
 fs/afs/Kconfig                                    |    8 +
 fs/afs/Makefile                                   |    3 +
 fs/afs/cache.c                                    |  503 ++++++++-----
 fs/afs/cache.h                                    |   15 +-
 fs/afs/cell.c                                     |   16 +-
 fs/afs/file.c                                     |  220 ++++--
 fs/afs/inode.c                                    |   31 +-
 fs/afs/internal.h                                 |   53 +-
 fs/afs/main.c                                     |   27 +-
 fs/afs/mntpt.c                                    |    4 +-
 fs/afs/vlocation.c                                |   25 +-
 fs/afs/volume.c                                   |   14 +-
 fs/afs/write.c                                    |   21 +
 fs/cachefiles/Kconfig                             |   39 +
 fs/cachefiles/Makefile                            |   18 +
 fs/cachefiles/bind.c                              |  286 +++++++
 fs/cachefiles/daemon.c                            |  755 ++++++++++++++++++
 fs/cachefiles/interface.c                         |  449 +++++++++++
 fs/cachefiles/internal.h                          |  360 +++++++++
 fs/cachefiles/key.c                               |  159 ++++
 fs/cachefiles/main.c                              |  106 +++
 fs/cachefiles/namei.c                             |  771 ++++++++++++++++++
 fs/cachefiles/proc.c                              |  134 ++++
 fs/cachefiles/rdwr.c                              |  879 +++++++++++++++++++++
 fs/cachefiles/security.c                          |  116 +++
 fs/cachefiles/xattr.c                             |  291 +++++++
 fs/fscache/Kconfig                                |   56 ++
 fs/fscache/Makefile                               |   19 +
 fs/fscache/cache.c                                |  415 ++++++++++
 fs/fscache/cookie.c                               |  500 ++++++++++++
 fs/fscache/fsdef.c                                |  144 ++++
 fs/fscache/histogram.c                            |  109 +++
 fs/fscache/internal.h                             |  380 +++++++++
 fs/fscache/main.c                                 |  124 +++
 fs/fscache/netfs.c                                |  103 +++
 fs/fscache/object.c                               |  810 +++++++++++++++++++
 fs/fscache/operation.c                            |  459 +++++++++++
 fs/fscache/page.c                                 |  816 +++++++++++++++++++
 fs/fscache/proc.c                                 |   68 ++
 fs/fscache/stats.c                                |  212 +++++
 fs/nfs/Kconfig                                    |    8 +
 fs/nfs/Makefile                                   |    1 +
 fs/nfs/client.c                                   |   14 +-
 fs/nfs/file.c                                     |   38 +-
 fs/nfs/fscache-index.c                            |  337 ++++++++
 fs/nfs/fscache.c                                  |  523 ++++++++++++
 fs/nfs/fscache.h                                  |  220 +++++
 fs/nfs/inode.c                                    |   14 +
 fs/nfs/internal.h                                 |    4 +
 fs/nfs/iostat.h                                   |   18 +
 fs/nfs/read.c                                     |   27 +-
 fs/nfs/super.c                                    |   45 +-
 fs/splice.c                                       |    3 +-
 fs/super.c                                        |    1 +
 include/linux/fscache-cache.h                     |  505 ++++++++++++
 include/linux/fscache.h                           |  618 +++++++++++++++
 include/linux/nfs_fs.h                            |   13 +
 include/linux/nfs_fs_sb.h                         |   11 +
 include/linux/nfs_iostat.h                        |   12 +
 include/linux/page-flags.h                        |   40 +-
 include/linux/pagemap.h                           |    5 +
 include/linux/slow-work.h                         |   95 +++
 init/Kconfig                                      |   12 +
 kernel/Makefile                                   |    1 +
 kernel/slow-work.c                                |  640 +++++++++++++++
 kernel/sysctl.c                                   |    9 +
 mm/filemap.c                                      |   21 +
 mm/migrate.c                                      |   10 +-
 mm/readahead.c                                    |   40 +-
 mm/swap.c                                         |    4 +-
 mm/truncate.c                                     |   10 +-
 mm/vmscan.c                                       |    6 +-
 security/security.c                               |    2 +
 82 files changed, 15414 insertions(+), 390 deletions(-)
 create mode 100644 Documentation/filesystems/caching/backend-api.txt
 create mode 100644 Documentation/filesystems/caching/cachefiles.txt
 create mode 100644 Documentation/filesystems/caching/fscache.txt
 create mode 100644 Documentation/filesystems/caching/netfs-api.txt
 create mode 100644 Documentation/filesystems/caching/object.txt
 create mode 100644 Documentation/filesystems/caching/operations.txt
 create mode 100644 Documentation/slow-work.txt
 create mode 100644 fs/cachefiles/Kconfig
 create mode 100644 fs/cachefiles/Makefile
 create mode 100644 fs/cachefiles/bind.c
 create mode 100644 fs/cachefiles/daemon.c
 create mode 100644 fs/cachefiles/interface.c
 create mode 100644 fs/cachefiles/internal.h
 create mode 100644 fs/cachefiles/key.c
 create mode 100644 fs/cachefiles/main.c
 create mode 100644 fs/cachefiles/namei.c
 create mode 100644 fs/cachefiles/proc.c
 create mode 100644 fs/cachefiles/rdwr.c
 create mode 100644 fs/cachefiles/security.c
 create mode 100644 fs/cachefiles/xattr.c
 create mode 100644 fs/fscache/Kconfig
 create mode 100644 fs/fscache/Makefile
 create mode 100644 fs/fscache/cache.c
 create mode 100644 fs/fscache/cookie.c
 create mode 100644 fs/fscache/fsdef.c
 create mode 100644 fs/fscache/histogram.c
 create mode 100644 fs/fscache/internal.h
 create mode 100644 fs/fscache/main.c
 create mode 100644 fs/fscache/netfs.c
 create mode 100644 fs/fscache/object.c
 create mode 100644 fs/fscache/operation.c
 create mode 100644 fs/fscache/page.c
 create mode 100644 fs/fscache/proc.c
 create mode 100644 fs/fscache/stats.c
 create mode 100644 fs/nfs/fscache-index.c
 create mode 100644 fs/nfs/fscache.c
 create mode 100644 fs/nfs/fscache.h
 create mode 100644 include/linux/fscache-cache.h
 create mode 100644 include/linux/fscache.h
 create mode 100644 include/linux/slow-work.h
 create mode 100644 kernel/slow-work.c
        
---
These patches add local caching for network filesystems such as NFS.  To give a
really quick overview of the way the facility works:

	+---------+
	|         |
	|   NFS   |--+
	|         |  |
	+---------+  |   +----------+
	             |   |          |
	+---------+  +-->|          |
	|         |      |          |
	|   AFS   |----->| FS-Cache |
	|         |      |          |--+
	+---------+  +-->|          |  |
	             |   |          |  |   +--------------+   +--------------+
	+---------+  |   +----------+  |   |              |   |              |
	|         |  |                 +-->|  CacheFiles  |-->|  Ext3        |
	|  ISOFS  |--+                     |  /var/cache  |   |  /dev/sda6   |
	|         |                        +--------------+   +--------------+
	+---------+


 (1) NFS, say, asks FS-Cache to store/retrieve data for it;

 (2) FS-Cache asks the cache backend, in this case CacheFiles to honour the
     operation;

 (3) CacheFiles 'opens' a file in a mounted filesystem, say Ext3, and does read
     and write operations of a sort on it;

 (4) Ext3 decides how the cache data is laid out on disk - CacheFiles just
     attempts to use one sparse file per netfs inode.

 (5) If NFS asks for data from the cache, but the file has a hole in it, NFS
     falls back to asking the server.  The data obtained from the server is
     then written over the hole in the file.

To look at it another way:

	+---------+
	|         |
	| Server  |
	|         |
	+---------+
	     |                  NETWORK
	~~~~~|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	     |
	     |           +----------+
	     V           |          |
	+---------+      |          |
	|         |      |          |
	|   NFS   |----->| FS-Cache |
	|         |      |          |--+
	+---------+      |          |  |   +--------------+   +--------------+
	     |           |          |  |   |              |   |              |
	     V           +----------+  +-->|  CacheFiles  |-->|  Ext3        |
	+---------+                        |  /var/cache  |   |  /dev/sda6   |
	|         |                        +--------------+   +--------------+
	|   VFS   |                                ^                     ^
	|         |                                |                     |
	+---------+                                +--------------+      |
	     |                  KERNEL SPACE                      |      |
	~~~~~|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|~~~~~~|~~~~
	     |                  USER SPACE                        |      |
	     V                                                    |      |
	+---------+                                           +--------------+
	|         |                                           |              |
	| Process |                                           | cachefilesd  |
	|         |                                           |              |
	+---------+                                           +--------------+

FS-Cache attempts to provide a caching facility to a network filesystem such
that it's transparent to the users of that network filesystem.


The patches can roughly be broken down into a number of sets:

  (*) 01-slow-work.diff
  (*) 02-slow-work-dynamic.diff
  (*) 03-slow-work-config.diff
  (*) 04-slow-work-doc.diff

      A thread pool for (very) slow work items, such as batches of lookup,
      mkdir, create and [sg]etxattr calls.

      It doesn't make sense to use an ordinary work queue because I want more
      than one thread, but I don't want to be limited to 1 thread per CPU.
      The work items in question take a long time, most of which is spent
      sleeping on I/O.  For the duration the worker thread is unable to do
      anything else.

      These four patches add the basic facility, make it dynamic, make it
      configurable and document it.


  (*) 05-release-page.diff

      Call the page release function after a failed readahead.

  (*) 06-fscache-page-flags.diff

      Add an extra page flag that FS-Cache then uses to keep track of whether a
      page is known by the cache, and to indicate that the cache must be
      informed if the page is going to go away.  It's an indication to the
      netfs that the cache has an interest in this page, where an interest may
      be a pointer to it, resources allocated or reserved for it, or I/O in
      progress upon it.

      Note that the cache doesn't necessarily need to be able to find the netfs
      pages, but may have to allocate/pin resources for backing them.

      Further note that PG_private may not be used as I want to be able to use
      caching with ISOFS eventually, and PG_private is owned by the block
      buffer code.

      These bits can be otherwise used by any filesystem that doesn't want to
      use FS-Cache.


  (*) 07-fscache-netfs-api.diff
  (*) 08-fscache-backend-api.diff
  (*) 09-fscache-kconfig.diff
  (*) 10-fscache-proc.diff
  (*) 11-fscache-fsdef.diff
  (*) 12-fscache-tag-handling.diff
  (*) 13-fscache-cache-handling.diff
  (*) 14-fscache-cookie-jar.diff
  (*) 15-fscache-netfs-reg.diff
  (*) 16-fscache-bits.diff
  (*) 17-fscache-object.diff
  (*) 18-fscache-cookie.diff
  (*) 19-fscache-operation.diff
  (*) 20-fscache-io.diff

      Patches to provide a local caching facility for network filesystems.

      FS-Cache is a layer that takes requests from any one of a number of
      netfs's and passes them to an appropriate cache, if there is one.
      FS-Cache makes operations requested by the netfs transparently
      asynchronous where possible.

      FS-Cache also protects the netfs against (a) there being no cache, (b)
      the cache suffering a fatal I/O error and (c) the cache being removed;
      and protects the cache against (d) the netfs uncaching pages that the
      cache is using and (e) conflicting operations from the netfs, some of
      which may be queued for asynchronous processing.

      Five documents in text file format that describe the FS-Cache interface
      are added by these patches:

      Documentation/filesystems/caching/fscache.txt gives an overview of the
      facility and describes the statistical data it makes available.

      Documentation/filesystems/caching/netfs-api.txt describes the API by
      which a network filesystem would make use of the FS-Cache facility.

      Documentation/filesystems/caching/backend-api.txt describes the API that
      a cache backend must implement to provide caching services through
      FS-Cache.

      Documentation/filesystems/caching/object.txt describes the object
      management state machine used.

      Documentation/filesystems/caching/operations.txt describes the operation
      scheduling facility provided and used by FS-Cache that can also be used
      by cache backend modules.

      The patches provide the following components of the FS-Cache facility:

      (07) The netfs API header file and documentation.  A netfs can actually
      	   be built and run against just this patch.  It won't actually do
      	   anything without the later patches, though, but it will compile.

      (08) The cache backend API header file and documentation.

      (09) The main selector configuration option, the main module load/unload
      	   hooks and the debugging code declarations.  With this patch applied,
      	   it is possible to enable caching in a client netfs, though it won't
      	   actually do anything.

      (10) The /proc files for statistics presentation, plus the internal
      	   interfaces for driving it.

      (11) The top level index definition.

      (12) Cache reference tag handling.

      (13) Cache (un)registration and error handling.

      (14) Cookie (de)allocator and initialisation.

      (15) Netfs (un)registration handling.  This is partly usable.  Without a
      	   later patch, however, a cookie will be leaked from unregistration.

      (16) Bit waiting utility functions.

      (17) The object management state machine implementation and
      	   documentation.

      (18) Implementation of the cookie management part of the netfs API.  With
      	   this, it's possible for netfs's to actually be granted cookies and
      	   to release them without error.

      (19) Cache I/O operation scheduler and documentation.

      (20) Implementation of the data I/O part of the netfs API.


  (*) 21-cachefiles-monitor.diff
  (*) 22-cachefiles-export.diff
  (*) 23-cachefiles.diff

      Patches to provide a local cache in a directory of an already mounted
      filesystem.

      The latter patch adds a document in text file format that describes the
      CacheFiles cache backend and gives instructions on how it is set up and
      used.  This will be Documentation/filesystems/caching/cachefiles.txt when
      the patch is applied.

  (*) 24-afs-fscache.diff

      Patches to provide AFS with local caching.

  (*) 25-nfs-comment.diff
  (*) 26-nfs-fscache-option.diff
  (*) 27-nfs-fscache-kconfig.diff
  (*) 28-nfs-fscache-top-index.diff
  (*) 29-nfs-fscache-server-obj.diff
  (*) 30-nfs-fscache-super-obj.diff
  (*) 31-nfs-fscache-inode-obj.diff
  (*) 32-nfs-fscache-use-inode.diff
  (*) 33-nfs-fscache-invalidate-pages.diff
  (*) 34-nfs-fscache-iostats.diff
  (*) 35-nfs-fscache-page-management.diff
  (*) 36-nfs-fscache-read-context.diff
  (*) 37-nfs-fscache-read-fallback.diff
  (*) 38-nfs-fscache-read-from-cache.diff
  (*) 39-nfs-fscache-store-to-cache.diff
  (*) 40-nfs-fscache-display.diff
  (*) 41-nfs-fscache-mount.diff

      Patches to provide NFS with local caching.


I've been testing these patches by throwing batches of eight parallel "tar cf"
commands across three different 350MB NFS-based kernel trees (3 tars on first
tree, 3 on second, 2 on third), sometimes with one or more of the trees
preloaded into the cache.  The complete working data set does not fit into the
RAM of my test machine, so even three tars that can be entirely satisfied from
the cache may have to reread everything from disk.

I've also been running tars against AFS mounted kernel trees.

--
A tarball of the patches is available at:

	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-48.tar.bz2

This builds on top of Linus's current kernel.

The code can also be obtained by GIT from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-fscache.git
	http://www.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-fscache.git

tagged as 'fscache-48'.

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
