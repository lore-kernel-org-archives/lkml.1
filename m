Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbXDTJWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbXDTJWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 05:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbXDTJWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 05:22:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:22785 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbXDTJWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 05:22:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Clg2D/25jr3hSKYRd/qS0pordCb+byDzlxnjVI/jHpPWZM4WOLvNB1p1ias7WgT9YSYCbAv/eV6wnB0D+wE3vRVAMcX7PMGQrnqgLf9ZoAWn4BjtA2SGOsFJ0ee/v/0Evvp5P6jCPbd550klpj6XFAX8LctYMtSbvdi7A/By8po=
Message-ID: <46288645.3090201@gmail.com>
Date: Fri, 20 Apr 2007 12:22:13 +0300
From: Sergey Yanovich <ynvich@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
References: <4627D6CB.1050107@gmail.com> <200704200056.33866.arnd@arndb.de>
In-Reply-To: <200704200056.33866.arnd@arndb.de>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Arnd Bergmann wrote:
> As very general comments, you should have the maintainer of the subsystem
> (Pierre in this case) on Cc when posting a driver, and you should include
> the patch inline in your mail, see Documentation/SubmittingPatches.
>   
I have cc'ed both Pierre and Alex, but my first message was blocked
by the list as it contained html.

For inlinning, this is my first kernel patch. I have just followed
http://www.tux.org/lkml/#s2-2.
> You should include the Makefile and Kconfig changes in the same patch/mail,
> no point splitting these out.
>   
Once again it was an advise from http://www.tux.org/lkml/#s1-10. 
<http://www.tux.org/lkml/#s1-10>
> Don't define your own DBG macro, instead use the predefined dev_dbg()
> that has a similar definition.
>   
Somewhere in 0.5-0.6 version this driver has issues with timeouts , 
which were
revealing in a non-debug kernel builds only . So this was a nessecity. I 
will purge
them now.
> Your mmc_tifm_irq_chip() function does a _very_ long delay of 100
> miliseconds. This is normally not acceptable, since it is a noticeable
> time in which the system is completely unresponsive. Maybe you can convert
> the tasklet to a workqueue, which lets you call msleep instead of mdelay.
>   
This is done intentionally to prevent a race condition when a card is 
removed
and immediately reinserted. There may be a more complicated way to solve 
this
issue, but didn't think about them. This only happens when an MMC/SD 
card is
inserted/removed. And it takes at least as long to process the event in 
other
parts of subsystem.
> Your use of pci_map_sg() looks wrong, you simply can't assume that the
> return value is '1' in general. I've stumbled over that same problem
> in the sdhci driver, so it may be inherent to the mmc layer and not
> be driver specific.
>   
This is taken as is from [tifm_sd]. I suppose this relates to a hardware
limitation:

+	mmc->max_hw_segs = 1;
+	mmc->max_phys_segs = 1;


Best regards,
Sergey
