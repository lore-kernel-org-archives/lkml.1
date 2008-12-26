Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbYLZTUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbYLZTUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 14:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYLZTUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 14:20:31 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:36600 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751156AbYLZTUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 14:20:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6MS6opnPMsOpZpu6zZthl7PZ+e1G6uHYCCQSASB4txAosdVRfWWkzpAbDJ6XlJDZH0D1ahX4/BuP+8B5wvEQJp5TK3Zw0cC/VDb5mY9OhktCV7sJVaL/HQwPEVNEg/2FSaNUikJXuH0qfqOGAmDzGy54JIoGrrzbz4KCayiY+iI=  ;
X-YMail-OSG: U_5F6tUVM1nq.dknGB4yp_qM6ppzOCX8Uw4buCDkNKlUzCNSMMstu8q0k1zYaS_d_KpIM3TuONIPRvwY_G9tAXq0zupq3IMMn1DDPPvXeIH4e2fDCKNUlmLe8vUBePdpCTdjAKcjAl5VXMHS42BPa7.kzlTfF_YzxejakiJkrkvF.z50LJx.Tb3p7FLL
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [PATCH] AMD Geode CS553X GPIO driver
Date: Fri, 26 Dec 2008 11:20:28 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, linux-geode@lists.infradead.org
References: <20081224234321.0890274e@i1501.lan.towertech.it> <200812261024.07303.david-b@pacbell.net> <20081226193854.41cbee89@i1501.lan.towertech.it>
In-Reply-To: <20081226193854.41cbee89@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200812261120.28834.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 December 2008, Alessandro Zummo wrote:
> > >  It uses the gpio framework and the gpio api as defined in
> > >  arch/x86/kernel/geode_32.c
> > 
> > Eventually I'd hope to see those geode_32.c calls just vanish.
> > 
> > In fact, the "normal" way to package these GPIOs would be to
> > always provide them through the standard API, in arch/... code,
> > with no Kconfig option.  Any reason you shouldn't do that in
> > this patch?
> 
>  I didn't want to mess with something I did not wrote.

Such messing is part'n'parcel of updating the kernel though.  :)


>  Maybe a two steps 
>  approach can convince people to move on ;) (you remember what happened
>  with people holding their old rtc code tight :) )

The RTC case was different ... driver structure needed to
either use the new framework, or the old.  Except for that
drivers/rtc/rtc-ppc.c migration aid, letting some of them
coexist until the older ppc_md stuff gets updated.  That is,
switching from one full-fledged driver to another one needs
some kind of scheduled flag day.  (Plus completing kernel
infrastructure, of which NTP support is probably the most
significant missing part right now.)

If you add this to the geode_32.c file it'll just provide a
standard interfaces, which can coexist with the older stuff
until it's removed.  Several of the ARM platforms have
exactly that kind of coexistence going on.  (Example, OMAP;
which in 2.6.29 will stops using its legacy GPIO calls.)

- Dave

