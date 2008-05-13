Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYEMDc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYEMDc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 23:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbYEMDcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 23:32:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48584 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbYEMDcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 23:32:46 -0400
Date: Tue, 13 May 2008 00:32:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: V4L2-based build error
Message-ID: <20080513003230.52b36b78@gaivota>
In-Reply-To: <18844.1210630449@vena.lwn.net>
References: <18844.1210630449@vena.lwn.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Mon, 12 May 2008 16:14:09 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> If you configure V4L2 as a module, the config system will still let you
> configure DVB_CORE built-in.  This yields:
> 
>   drivers/built-in.o: In function `v4l2_i2c_drv_attach_legacy':
>   tuner-core.c:(.text+0x901d5): undefined reference to `v4l2_i2c_attach'
>   drivers/built-in.o: In function `tuner_command':
>   tuner-core.c:(.text+0x91aed): undefined reference to `v4l_printk_ioctl'
> 
> I never had trouble with this before 2.6.26-rc2.  I'm happy making
> DVB_CORE modular, but it would be nice if the config system didn't allow
> inconsistent setups.

I have a number of patches meant to fix several troubles at v4l/dvb
compilation. I intend to send they soon for merging, but I want first to test
some random builds.


> P.S. As I was digging into this, I ran into <media/v4l2-i2c-drv-legacy.h>, 
>      which takes an interesting approach - function definitions and 
>      module_init() within a header file?  This thing is included in a 
>      number of places; it seems like there should be a better way...

This file is meant to be an interim approach to allow a smoothly change from
the old i2c probing way to the newer format. It should be there for some time,
until we can convert all v4l2 drivers to the new approach.


Cheers,
Mauro
