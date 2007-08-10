Return-Path: <linux-kernel-owner+w=401wt.eu-S940096AbXHJQFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940096AbXHJQFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765167AbXHJQFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:05:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760490AbXHJQFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:05:20 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/16] Permit filesystem local caching [try #3]
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov
Date: Fri, 10 Aug 2007 17:04:55 +0100
Message-ID: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



These patches add local caching for network filesystems such as NFS and AFS.

FS-Cache now runs fully asynchronously as required by Trond Myklebust for NFS.

--
Changes:
[try #3]:

 (*) Added missing file to CacheFiles patch.

 (*) Made new security functions return errors and pass actual return data via
     argument pointer.

 (*) Cleaned up NFS patch.

 (*) The 'fsc' flag must now be passed to NFS mount by the string options.

 (*) Split the NFS patch into three as requested by Trond.

[try #2]:

 (*) The CacheFiles module no longer accepts directory fds in its cull and
     inuse commands from cachefilesd.  Instead it uses the current working
     directory of the calling process as the basis for looking up the object.
     Corollary to this, fget_light() no longer needs to be exported.

--
A tarball of the patches is available at:

	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-22.tar.bz2


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
