Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbZFPUkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbZFPUkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762340AbZFPUjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:39:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59573 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762065AbZFPUjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:39:52 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org
Date: Tue, 16 Jun 2009 21:38:45 +0100
Message-ID: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This series of patches provides a pioctl() system call, and makes kAFS use it
to provide a number of of the OpenAFS pioctl functions sufficient to allow a
number of OpenAFS userspace utilities work with kAFS.

File-requiring pioctls have been tested with:

	[root@andromeda ~]# fs getfid /afs
	File /afs (1.1.0) contained in volume 1
	[root@andromeda ~]# fs whichcell /afs
	File /afs lives in cell 'procyon.org.uk'
	[root@andromeda ~]# fs examine /afs
	fs: You don't have the required access rights on '/afs'
	[root@andromeda ~]# fs whereis /afs
	File /afs is on host altair.procyon.org.uk 

Non-file-requiring pioctls for manipulating authentication tokens have been
tested with:

	[root@andromeda ~]# kinit admin/admin
	Password for admin/admin@PROCYON.ORG.UK: 
	[root@andromeda ~]# klog admin
	Password:
	[root@andromeda ~]# keyctl show
	Session Keyring
	       -3 --alswrv      0     0  keyring: _ses
	939040040 --als--v      0     0   \_ rxrpc: afs@PROCYON.ORG.UK
	[root@andromeda ~]# fs examine /afs
	File /afs (1.1.32558) contained in volume 1
	Volume status for vid = 536870912 named 
	Current disk quota is 5000
	Current blocks used are 2
	The partition has 39007484 blocks available out of 39187776

	[root@andromeda ~]# aklog
	[root@andromeda ~]# keyctl show
	Session Keyring
	       -3 --alswrv      0     0  keyring: _ses
	660792724 --als--v      0     0   \_ rxrpc: afs@PROCYON.ORG.UK
	[root@andromeda ~]# tokens

	Tokens held by the Cache Manager:

	User's (AFS ID 10143) tokens for afs@PROCYON.ORG.UK [Expires Jun 17 00:47]
	   --End of list--

The AFS keys probably should be in their own keyring which is linked to from
the session keyring.
