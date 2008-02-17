Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYBQUXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYBQUXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbYBQUXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:23:04 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37380 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbYBQUXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:23:01 -0500
Date: Sun, 17 Feb 2008 15:22:45 -0500
Message-Id: <200802172022.m1HKMjMg019094@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make vfs_ioctl() static 
In-reply-to: Your message of "Sun, 17 Feb 2008 08:18:39 EST."
             <20080217131839.GA11034@infradead.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080217131839.GA11034@infradead.org>, Christoph Hellwig writes:
> On Sun, Feb 17, 2008 at 10:18:42AM +0200, Adrian Bunk wrote:
> > This patch makes the needlessly global vfs_ioctl() static.
> 
> I think the point was toa eventually export it for stackable filesystem
> use.  But until they start using it marking it static seems fine with
> me.

Right.  I'm not using it yet in unionfs, although I could; for now I'm just
calling very similar code myself.  This is only used in unionfs after I
process my own ioctls; IOW, I pass all unknown ioctls to the lower level and
let it handle it.

eCryptfs, however, doesn't pass unknown ioctls to the lower layer: it only
processes its own.

Honestly I'm not sure which is more appropriate: should a stackable f/s pass
unknown ioctls to the lower f/s or not?  If it doesn't, would any important
functionality be lost?

Erez.
