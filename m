Return-Path: <linux-kernel-owner+w=401wt.eu-S1423415AbXBHV0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423415AbXBHV0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423416AbXBHV0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:26:34 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:50252 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1423415AbXBHV0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:26:33 -0500
Message-ID: <45CB9588.50300@vmware.com>
Date: Thu, 08 Feb 2007 13:26:32 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>	 <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com>	 <20070207123552.GD4481@ucw.cz>	 <1170880572.11736.4.camel@localhost.localdomain> <d120d5000702080643k453e73e3h6d481f9d65a4e856@mail.gmail.com>
In-Reply-To: <d120d5000702080643k453e73e3h6d481f9d65a4e856@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
>
> However I am not really fond of idea of adding constructs like this
> all over the code:
>
> #define USE_REAL_TIME_DELAY_I_REALLY_MEAN_IT_THIS_TIME_I_SWEAR
>
> as the time passes... Drivers should be blissfully ignorant of being
> run on virtual hardware.

I agree in general, but there are two uses for this ugly construct.  One 
is for drivers and isolated sections of code which actually interact 
with the real world.  They need real time delays.  The only two examples 
so far are SMP coprocessor bootstrapping and blinking LEDs with a 
recognizable frequency.  I don't expect many more to show up.

The other use for this construct is compiling a hardware privileged 
virtual domain that actually drives real hardware - you can just define 
this globally to override any delay masking.

Zach
