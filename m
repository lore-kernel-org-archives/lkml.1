Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbYD2Wpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbYD2Wpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYD2Wp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:45:27 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:45838 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752686AbYD2Wp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:45:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=j5Y99DuvJ+Q3xWvxdyvIHZA7v5WdYsaEXz4eYsW1aXucbQ+18OpnjB8kZyASezbZQRcpzpZFSlKsurFduKcdajfSmTT4iu99GTJe78q3H40zAnzMzRrBwuzWuwRNByyfyftKx+KaypTp08zDh4oEfawAw9I1jSg4SE0cbQ3rgTE=  ;
X-YMail-OSG: oxMnfN0VM1kAIJCT4vB0KsVnWvprhkhjjZEmaIOdxRtipGXkhZjTbrSFxVBnsf3AEZAfhjQBUH8YoHuTT0R8ARK9ia9l39SIT_CqaZyFean3aPgxm0lDohUJd9kZZFmkMjk-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Trent Piepho <tpiepho@freescale.com>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Tue, 29 Apr 2008 15:39:31 -0700
User-Agent: KMail/1.9.6
Cc: Ben Nizette <bn@niasdigital.com>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804281239.51729.david-b@pacbell.net> <200804282044.00706.david-b@pacbell.net> <Pine.LNX.4.64.0804282251420.8286@t2.domain.actdsltmp>
In-Reply-To: <Pine.LNX.4.64.0804282251420.8286@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804291539.31577.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008, Trent Piepho wrote:
> We have a flash chip with a hardware write protected boot block controlled by
> a gpio.  If we want to flash this block, we need a way to change the gpio. 
> patching the mtd driver to do this automatically would require maintaining an
> out-of-tree patch, I like to avoid those.  We'd also rather mtd didn't
> automatically un-write-protect the boot block; kinda defeats the purpose.
> 
> The device may have a daughtercard installed in it.  There is a gpio used as a
> presence detect.  We want to be able, from userspace (any maybe kernel too),
> to print out "card installed" or "no card installed".  There is also certain
> stuff that should run if the card is present when the machine boots.
> 
> We have some PCA9557 I2C gpio expanders that encode a device version number. 
> We want to print this number out in userspace (e.g.  show it in the web
> interface, various other application specific interfaces, etc.).  Maybe the
> kernel will need to know too, we'll see what happens when there is a version
> two.  The daughter card also has a PCA9557 expander, but of course it might
> not be connected, the pca9557 driver can probe the bus for this.

Good examples.  Note that the "daughtercard installed" cases generalize
somewhat ... it's not uncommon to do like DRAM sticks do with SPD EEPROMS,
and have a cheap EEPROM identifying characteristics of that card, since
different cards need different initialization/setup.

However, I think a slightly more common practice in current embedded
Linux systems is to build custom kernels that know which daughtercard(s)
are available.  That's mostly what gets pushed upstream, anyway...

ISTR that Gumstix distro kernels use a more retro scheme to identify what's
in the card stack:  they poke at various peripheral addresses to see if the
device on a given card is there.  In the PC space, that's what "ISA Legacy
Drivers" do, albeit at the level of individual peripherals, not cards.

- Dave

