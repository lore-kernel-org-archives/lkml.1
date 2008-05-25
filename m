Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbYEYXqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbYEYXqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 19:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYEYXq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 19:46:27 -0400
Received: from cnc.isely.net ([64.81.146.143]:54222 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbYEYXq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 19:46:26 -0400
Date: Sun, 25 May 2008 18:46:24 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Video4Linux list <video4linux-list@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCH] video4linux: Push down the BKL
In-Reply-To: <20080522223700.2f103a14@core>
Message-ID: <Pine.LNX.4.64.0805251835520.25571@cnc.isely.net>
References: <20080522223700.2f103a14@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Alan Cox wrote:

> For most drivers the generic ioctl handler does the work and we update it
> and it becomes the unlocked_ioctl method. Older drivers use the usercopy
> method so we make it do the work. Finally there are a few special cases.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

The pvrusb2 driver already should not require the BKL.  Though since 
this driver (like every V4L driver) is using video_usercopy() then it's 
obviously going along for the ride here with respect to the overall 
issue here in pushing the lock down into video_usercopy().  In the mean 
time, for the pvrusb2 portion of this patch...

Acked-By: Mike Isely <isely@pobox.com>

  -Mike

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
