Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYC1RZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYC1RZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 13:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYC1RYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 13:24:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52412 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbYC1RYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 13:24:52 -0400
Date: Fri, 28 Mar 2008 14:24:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v4l & compat_ioctl
Message-ID: <20080328142408.6c8dc198@gaivota>
In-Reply-To: <20080328133537.GS29105@one.firstfloor.org>
References: <47ECD0CF.1020003@gmail.com>
	<87y783jdjo.fsf@basil.nowhere.org>
	<47ECD715.90507@gmail.com>
	<20080328113803.GQ29105@one.firstfloor.org>
	<47ECE318.1030809@gmail.com>
	<20080328133537.GS29105@one.firstfloor.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008 14:35:37 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> On Fri, Mar 28, 2008 at 01:22:48PM +0100, Jiri Slaby wrote:
> > On 03/28/2008 12:38 PM, Andi Kleen wrote:
> > >BTW i haven't audited them, but if there is u64 or similar in there 
> > >anywhere
> > >be careful about alignment.
> > 
> > Well, not good, some ioctls have different numbers on 32 and 64 bit:
> 
> Then you need compat handlers to translate the numbers.

V4L has its 32 bits compat module already, defined on
drivers/media/video/compat_ioctl32.c.

Also, the drivers should have this:

        .compat_ioctl = v4l_compat_ioctl32,

on their fops tables:

$ ls -C `grep -l compat_ioctl32 *.c|grep -v mod`

arv.c             meye.c              radio-rtrack2.c   stk-webcam.c
bttv-driver.c     miropcm20-radio.c   radio-sf16fmi.c   stradis.c
bw-qcam.c         ov511.c             radio-sf16fmr2.c  stv680.c
compat_ioctl32.c  pms.c               radio-si470x.c    usbvideo.c
cpia2_v4l.c       pwc-if.c            radio-terratec.c  usbvision-video.c
cpia.c            radio-aimslab.c     radio-trust.c     vicam.c
c-qcam.c          radio-aztech.c      radio-typhoon.c   w9966.c
cx23885-video.c   radio-cadet.c       radio-zoltrix.c   w9968cf.c
cx88-video.c      radio-gemtek.c      saa5249.c         zc0301_core.c
dsbr100.c         radio-gemtek-pci.c  saa7134-video.c   zoran_driver.c
em28xx-video.c    radio-maestro.c     se401.c
et61x251_core.c   radio-maxiradio.c   sn9c102_core.c

It seems that the problem you're suffering is specific to some driver.


Cheers,
Mauro
