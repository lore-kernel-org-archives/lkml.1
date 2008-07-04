Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYGDQum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYGDQum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYGDQuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:50:22 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:32369 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759421AbYGDQuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:50:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gy0wd5lZgx4AllqtSuNwj7ZzzGIS2pCeBIH9lmOqFbWDSPFTeBXplhRX5kQzZEL9PXwQSV0UN8KBdPUWZLkONOA3n/pYSbi3K8FFyTzB8hv4pW3UndWw0GPu1FQ7enVDQwagn5Id6MqsgB2J5Eo7Qn9eINMv8H960aXDutRpeKA=  ;
X-YMail-OSG: rORy9H8VM1lO9H3eWyg012xdcG_thtfxkBgB4pVHoSG_7woJiZtkRh9eNBsos7IoPBV.hJjrBoXtT3lHUqTwMQxrK2hddqOArU0UhRWBvbdvp_D6PRRmXnMwQEAFdzaUQ.0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] fix build error of driver/mfd/tc6393xb.c
Date: Fri, 4 Jul 2008 09:50:17 -0700
User-Agent: KMail/1.9.9
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <s5hiqvlc2ut.wl%tiwai@suse.de> <20080704124256.GB21747@doriath.ww600.siemens.net> <s5hk5g1ls9l.wl%tiwai@suse.de>
In-Reply-To: <s5hk5g1ls9l.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807040950.17877.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2008, Takashi Iwai wrote:
> 
> > The proper fix probably is to make PPC_MPC5200_GPIO also select
> > GENERIC_GPIO.

I think it's higher in the dependency tree than that.


> > I don't think that building GPIO_LIB w/o GENERIC_GPIO 
> > should be supported.
> 
> [Added David to Cc]
> 
> Then HAVE_GPIO_LIB should depend on GENERIC_GPIO.

They must go together ... right.  Anything using gpiolib
without the interface it implements needs a head-exam. ;)

But since ISTR that Kconfig (still) doesn't get dependencies
right when you "select" something that depends on something
else, that particular solution won't fly.


> Or, linux/gpio.h should be fixed so that the code can be built
> properly without GENERIC_GPIO.

No; GENERIC_GPIO is the interface, HAVE_GPIO_LIB is one
of the valid ways to implement it.

It should work if HAVE_GPIO_LIB selected GENERIC_GPIO...

- Dave

