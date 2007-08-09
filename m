Return-Path: <linux-kernel-owner+w=401wt.eu-S965971AbXHIQHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965971AbXHIQHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940163AbXHIQGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:06:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940092AbXHIQGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:06:10 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/14] Permit filesystem local caching [try #2]
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Aug 2007 17:04:38 +0100
Message-ID: <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com>
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

 (*) The CacheFiles module no longer accepts directory fds in its cull and
     inuse commands from cachefilesd.  Instead it uses the current working
     directory of the calling process as the basis for looking up the object.
     Corollary to this, fget_light() no longer needs to be exported.

--
A tarball of the patches is available at:

	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-21.tar.bz2


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
