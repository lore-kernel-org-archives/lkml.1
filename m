Return-Path: <linux-kernel-owner+w=401wt.eu-S1760553AbYBRRIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760553AbYBRRIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYBRRH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:07:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbYBRRH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:07:57 -0500
Date: Mon, 18 Feb 2008 14:07:40 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: build #355 issue for v2.6.25-rc2-15-g1309d4e in function
 v4l2_i2c_attach
Message-ID: <20080218140740.38746867@gaivota>
In-Reply-To: <200802181736.03492.rjw@sisk.pl>
References: <200802171121.13119.toralf.foerster@gmx.de>
	<20080218131300.529b9862@gaivota>
	<200802181736.03492.rjw@sisk.pl>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.7; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> > > drivers/built-in.o: In function `v4l2_i2c_attach':
> > > (.text+0x26c67): undefined reference to `i2c_attach_client'
> > > make: *** [.tmp_vmlinux1] Error 1
> > 
> > This bug were already fixed. I'm waiting for Linus to pull. The patches fixing
> > it are available at:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git
> 
> Specific commits or just everything?

There are three commits for this broken dependency, covered by bug #9823:
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=a9254475bbfbed5f0596d952c6a3c9806e19dd0b
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=1a4e30c3eaffb83218977477bb83d54316844acb
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=057596eea8402aa8f7a670bf3195665aa8267204

The above commits move some code from v4l2-common into videodev and fixes
Kconfig. After the three patches, videodev is not dependent anymore of
v4l2-common.

You should notice also that bug #9965 (marked as duplicate) pointed to the
above bug, and also to another one:
	ERROR: "release_firmware" [drivers/media/video/tuner-xc2028.ko] undefined! 
	ERROR: "request_firmware" [drivers/media/video/tuner-xc2028.ko] undefined!

The second bug is fixed by a separate commit:
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commit;h=ea35e3a754b2ba5f712c3f4df55e426ae2e4d60a

Cheers,
Mauro
