Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbYEWLBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbYEWLBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYEWLBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:01:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53345 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbYEWLBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:01:32 -0400
To: swhiteho@redhat.com
CC: miklos@szeredi.hu, hch@infradead.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
In-reply-to: <1211537930.3635.569.camel@quoit> (message from Steven Whitehouse
	on Fri, 23 May 2008 11:18:50 +0100)
Subject: Re: [patch 04/14] gfs2: dont call permission()
References: <20080521171458.077908538@szeredi.hu>
	 <20080521171546.697638614@szeredi.hu>
	 <20080523091805.GB27119@infradead.org>
	 <E1JzTsy-0001b8-Cr@pomaz-ex.szeredi.hu> <1211537930.3635.569.camel@quoit>
Message-Id: <E1JzV1K-0001m8-SN@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 23 May 2008 13:01:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Given the fact that (a) its only a very minor change and (b) as soon as
> we have a solution to what we really want to do:
> 
>  - inode/file operation:
>    - Do lookup via VFS
>    - Get GFS2 glock
>      - Do perm check via VFS
>      - Do actual operation
>    - Drop GFS2 glock

Well, fuse/nfs already do something similar, except they have their
actual permission checking in the server, as opposed to the vfs.  They
basically do:

 ->permission() does nothing

 ->foo_operation() does everything, including permission checking

The reality is a bit more complicated, and both nfs and fuse do
sometimes check permissions in ->permission() but most of the cases,
when they know that the permission will be checked later anyway they
just omit it.

Of course this would mean, that for example the LSM security checks
are not done within the gfs locked region.  Does that matter?

Miklos
