Return-Path: <linux-kernel-owner+w=401wt.eu-S1763154AbZD3V6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763154AbZD3V6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 17:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757959AbZD3V6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 17:58:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755003AbZD3V6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 17:58:05 -0400
Date: Thu, 30 Apr 2009 14:54:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: dvomlehn@cisco.com, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-scsi@cuplxvomd02.corp.sa.net,
       netdev@cuplxvomd02.corp.sa.net
Subject: Re: [PATCH 1/5] KERNEL: Support asynchronously-discovered boot
 devices, v4 (resend)
Message-Id: <20090430145412.c1386cb2.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0904301712450.31375-100000@netrider.rowland.org>
References: <20090430140559.a2343f7c.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0904301712450.31375-100000@netrider.rowland.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 17:19:34 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> > I wonder if we can think of something more new ad unique.  startupdev?  yuk.
> 
> Initdev?  Or does that mean something else also?

y:/usr/src/linux-2.6.30-rc4> grep -ril initdev . 
./drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
./drivers/net/mac8390.c
./drivers/video/kyro/Makefile
./drivers/video/kyro/STG4000InitDevice.c
./drivers/message/fusion/lsi/mpi_ioc.h
./drivers/watchdog/i6300esb.c
./drivers/media/video/cx88/cx88-alsa.c
./drivers/media/video/cx88/cx88-video.c
./drivers/media/video/saa7134/saa7134-core.c
./drivers/media/video/cx23885/cx23885-core.c

initdev sounds good to me.  Given that we're adding a new and distinct
concept which will remain with us for a long time, we should name it
with care.

> Really, these are devices that we want to have working before starting
> up any userspace processes.  These would be the console device(s) (so
> that the first process has open files for its stdin, stdout, and
> stderr) and the block device containing the root filesystem (if the
> initramfs image doesn't make its own arrangements).

OK, so "initdev" could be viewed as meaning "a device which /sbin/init
needs"?  Even I can understand that.

But /sbin/init isn't the first userspace we run, is it?  There's
initramfs stuff, firmware loaders, etc.

What's the story here?  Do we intend that all initdevs be up and
running before _any_ userspace runs?  Or is /sbin/init the red line?
