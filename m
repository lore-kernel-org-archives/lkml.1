Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYF2AoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYF2AoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 20:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYF2Anz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 20:43:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYF2Any (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 20:43:54 -0400
Date: Sat, 28 Jun 2008 21:43:35 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Greg KH <greg@kroah.com>, v4l-dvb-maintainer@linuxtv.org,
       linux-usb@vger.kernel.org, dean@sensoray.com,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] add Sensoray 2255 v4l driver
Message-ID: <20080628214335.40185450@gaivota>
In-Reply-To: <1214690914.7722.10.camel@pc10.localdom.local>
References: <20080626231551.GA20012@kroah.com>
	<20080628083154.33d3a93d@gaivota>
	<1214690914.7722.10.camel@pc10.localdom.local>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hermann,

On Sun, 29 Jun 2008 00:08:34 +0200
hermann pitton <hermann-pitton@arcor.de> wrote:


> On an attempt to get recent drivers on a FC8 x86_64 machine to watch
> Glastonbury music festival on BBC HD DVB-S with the saa714 driver on an
> recently updated 2.6.25 FC kernel it also fails to compile on some
> strlcpy attempt. Same with a 2.6.24 on the mail machine here.
> 
>   CC [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/quickcam_messenger.o
>   CC [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.o
> /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c: In function 'vidioc_querycap':
> /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c:809: error: implicit declaration of function 'dev_name'
> /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c:809: warning: passing argument 2 of 'strlcpy' makes pointer from integer without a cast

The code is not backward compatible. It works only with 2.6.27-rc.

I'll add the macro ballow at compat.h to allow its out of tree compilation:

#define dev_name(dev)  ((dev)->bus_id)

This simple macro worked fine with 2.6.25.6.

Cheers,
Mauro
