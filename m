Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbZIGLeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbZIGLeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 07:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZIGLea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 07:34:30 -0400
Received: from ns.penguin.cz ([84.21.108.25]:60579 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbZIGLea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 07:34:30 -0400
Subject: Re: Zaurus suspend saga
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Andrea Adami <andrea.adami@gmail.com>
In-Reply-To: <20090907110307.GK23450@elf.ucw.cz>
References: <20090906052653.GB1324@ucw.cz>
	 <1252276145.17852.15.camel@dax.rpnet.com>
	 <f17812d70909061806y651c390w1faa5364f0fb6ddc@mail.gmail.com>
	 <20090907110307.GK23450@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 13:34:29 +0200
Message-Id: <1252323270.14911.20.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> Yep, zaurus is currently pretty broken; I don't think charging from
> Linux works at all, so I simply power down back to bootloader for
> charge.
> 
> Anyway, suspend/resume is currently more important for me than charge,
> and I'd like to get at least that to work.
> 
> Could we apply the trivial patch from "zaurus c3000 aka spitz: fix
> resume" , and preferably push it to linus for 2.6.31? One version
> where kernel suspends/resumes would be good. 

I vote for applying Pavel's patch, as it fixes suspend/resume. Emergency
suspend may happen later, when SPI will be fully resumed. If future
fixes provide early SPI resume, then this patch may be reverted.

Tested-by: Stanislav Brabec <utx@penguin.cz>

...

Remaining Zaurus SL-C3200 problems in the current vanilla (regressions
are compared with 2.6.26-RP):


Offline charging. (regression)

Offline charging does not work.

Richard provided exact analysis of the problem.


Serial after resume. (regression)

Resume on serial port does not work. Reason unknown.


Call eject on HDD CF slot, then access. (probably in all kernels)

Instead of an error, it causes overwriting of partition table. It does
never happen in a normal work.


USB host does not work (regression), USB OTG switching is not
implemented (not yet implemented)

Reason unknown, but it may be caused by a lacking or incomplete platform
description.


Noisy touchscreen. (at least partially regression)

Touchscreen is noisy. I the latest versions, it even reads intermediate
values before the new value settles.

Possible fix: Do not read hundreds times in second, but only once in the
gap between two display refreshes.


Bad MTD partition table. (not yet implemented)

SL-C3100 and SL-C3200 differs in the NAND partition table. To get a
correct table, NAND config has to be read. Andrea Adami works on
kexecboot, that will be able to provide the NAND-configured table
instead of guessing using hardwired model->partition table list.


Missing driver for remote. (outside vanilla tree)

The driver exists outside the kernel tree, but it's ugly. I plan to
finish my "resistor matrix keyboard device" driver.


Sound codec on low frequencies. (not yet tested in 2.6.31)

It works, but sound is very distorted.

Possible reason: bad timing of chip auto suspend


-- 
Stanislav Brabec
http://www.penguin.cz/~utx

