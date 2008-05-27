Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbYE0Pl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbYE0Pl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757937AbYE0Plr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:41:47 -0400
Received: from vena.lwn.net ([206.168.112.25]:36238 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080AbYE0Plq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:41:46 -0400
Date: Tue, 27 May 2008 09:41:44 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
Message-ID: <20080527094144.1189826a@bike.lwn.net>
In-Reply-To: <20080527101039.1c0a3804@gaivota>
References: <20080522223700.2f103a14@core>
	<20080526135951.7989516d@gaivota>
	<20080526202317.GA12793@devserv.devel.redhat.com>
	<20080526181027.1ff9c758@gaivota>
	<20080526220154.GA15487@devserv.devel.redhat.com>
	<20080527101039.1c0a3804@gaivota>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 10:10:39 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:


> What if we create 3 functions:
> 
> video_ioctl2_bkl()
> video_ioctl2_serialized()
> video_ioctl2_unlocked()
> 
> The first patch will point .ioctl_unlock to video_ioctl2_bkl. 
> 
> A next step would be to move the drivers to use the serialized one. 

So we're replacing the big kernel lock with the big v4l2 lock.  That
might help the situation, but you'd need to be sure to serialize
against other calls (open(), for example) which are also currently done
under the BKL.

> IMO, we need to create a multi-thread stress userspace tool for
> checking the locks at the ioctls. There are a few testing utils at
> mercurial tree, under v4l2-apps/test. This can be a starting point
> for this tool. Also, Brandon improved one of those tools to work with
> multithread.

I don't think that stress tools are the way to eliminate the BKL.
You'll never find all the problems that way.  There's really no way to
avoid the task of actually *looking* at each driver and ensuring that
it has its act together with regard to locking.

jon
