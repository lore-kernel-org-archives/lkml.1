Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbZBVNEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbZBVNEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 08:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZBVND6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 08:03:58 -0500
Received: from mx0.towertech.it ([213.215.222.73]:42654 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751189AbZBVND5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 08:03:57 -0500
Date: Sun, 22 Feb 2009 14:03:52 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <w.sang@pengutronix.de>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux-arm@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: PCF8583 not detected on RiscPC
Message-ID: <20090222140352.5cd02fd6@i1501.lan.towertech.it>
In-Reply-To: <20090222112654.GC28025@n2100.arm.linux.org.uk>
References: <20090221194814.GA24385@n2100.arm.linux.org.uk>
	<20090221204147.GA25408@n2100.arm.linux.org.uk>
	<20090222011936.35b21d6b@i1501.lan.towertech.it>
	<20090222082829.GG16596@n2100.arm.linux.org.uk>
	<20090222104205.4539d3ef@i1501.lan.towertech.it>
	<20090222095150.GA28025@n2100.arm.linux.org.uk>
	<20090222113544.4501f06a@i1501.lan.towertech.it>
	<20090222112654.GC28025@n2100.arm.linux.org.uk>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009 11:26:54 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:


> I refer you to bb71f99f8daefb4a2c2441298bc127aaff9af947 and the
> discussion resulting from that commit, and changed in your commit
> 09a21e56dc3767ce444e21c1383d587b261af13c.

 As I said, the driver was born without the additional
 depend. 

 http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9c0c570576d02000063e28faadcce8c07396755d

 You then added it in

 http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=bb71f99f8daefb4a2c2441298bc127aaff9af947
 
 crating an arch specific driver from a driver that
 was mostly generic. I wasn't in Cc and I didn't noticed at that time.

  If you had it sent to me I would have told you that it
 was plain wrong. 

 When I did the Kconfig cleanup I noticed an additional
 dependency and removed it. This was not done because I don't
 like acorn, the arm stuff (to which I have too contributed)
 or anyone else.


> >  I don't know who converted the acorn platform to
> >  use it and I can't care less. Who did should have checked the driver 
> >  for compatibility with his own platform before migrating from the driver under
> >  drivers/char/ .
> 
> Which bit of "it used to work" did you miss?  At the time of converesion,
> it was checked and after some initial trivial bug fixing and it was
> working, and continued to work up until this recent breakage.

 I was discussing about the non-platform-specific nature of the driver.

 The breakage happened because the whole i2c stack has been revamped.
 It has been discussed for a long time and we have spent much effort
 to ensure that everything was correct. However we can all fail.
 I have checked all the files in the arch directory searching for
 i2c users. acorn was not there and I missed it.

 That said, the kernel is evolving continuously and once you reported
 the problem Jean and I actively worked to fix it.

 I'm not stating that we had not a problem or that the there wasn't
 a breakage. Only that the fault is not in the driver itself but
 on how the platform uses it. And that's why I refuse a revert-everything
 approach.

 If a better communication approach had been established in the past
 this probably wouldn't have happened.


> >  As far as I can see with git log, you applied changes to the driver
> >  multiple times, without having me in Cc nor G. Liakhovetski (who did
> >  the port).
> 
> I don't add CC entries to commits, so you can't make that assumption.

 Please check your archive, but I'm pretty sure I would have noticed
 an email with a subject. I don't see it in my archives nor in the 
 mailing list.

 [ARM] rtc-pcf8583: Final fixes for this RTC on RiscPC

 If you did sent it to me or to the list and I hadn't noticed, I beg your pardon.

> However, I did talk to Guennadi around the time of those changes about
> some of the issues therein, in particular adding back the I2C address of
> the PCF8583.

 So you and Guennadi knew but not everyone else.
 
> Most of those other changes were trivial bug fixes, and I do apologise
> for not copying you with those.

 I accept the apologies but you don't need to copy me for those, we
 have trivial@ for those, which usually Ccs me. And there's Andrew who
 kindly gives a look at everything.

 But when things are important I do appreciate to see it at the proper time.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

