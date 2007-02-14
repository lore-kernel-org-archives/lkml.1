Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXBNVxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXBNVxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932665AbXBNVxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:53:11 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:51034 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932659AbXBNVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:53:10 -0500
Message-ID: <45D384C4.2000306@vmware.com>
Date: Wed, 14 Feb 2007 13:53:08 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>	<20070206122729.GC47229@muc.de>	<45C8FA2D.6010706@vmware.com>	<20070207123552.GD4481@ucw.cz>	<1170880572.11736.4.camel@localhost.localdomain>	<20070214125216.2befda78@localhost.localdomain>	<45D36B49.5090109@vmware.com> <20070214213423.4834941b@localhost.localdomain>
In-Reply-To: <20070214213423.4834941b@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
>> ???  I fail to see the code bloat and also the fast paths.  Which fast 
>> paths use udelay?
>>     
>
> IDE on several platforms has performance critical paths that use
> ndelay(400) or failing that udelay(1)

Ok, I buy that.  A 486DX / 33 Mhz processor takes 10 cycles to issue a 
CALL / RET pair.  This is about 300ns.  Is there an issue with being too 
early to issue I/O operations or too late?

If it is too early, then we have lost 10 cycles of processor time per 
udelay, which considering the antiquity of this piece of hardware, seems 
acceptable.

If it is too late, then there could be a real issue on older machines.  
But I fail to see how such careful timing can be done at this 
granularity on such hardware without well tweaked assembly code.  A 
suboptimal compile output could easily throw you off by just as much, 
sticking a little bit of arithmetic before and after the delay.

Zach
