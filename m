Return-Path: <linux-kernel-owner+w=401wt.eu-S1161458AbXBGWXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161458AbXBGWXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161455AbXBGWXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:23:52 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41672 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161454AbXBGWXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:23:51 -0500
Message-ID: <45CA5176.4000306@vmware.com>
Date: Wed, 07 Feb 2007 14:23:50 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Pavel Machek <pavel@ucw.cz>, Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>	 <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com>	 <20070207123552.GD4481@ucw.cz> <1170880572.11736.4.camel@localhost.localdomain>
In-Reply-To: <1170880572.11736.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wed, 2007-02-07 at 12:35 +0000, Pavel Machek wrote:
>   
>> Ugh, it sounds like paravirt is more b0rken then I thought. It should
>> always to the proper delay, then replace those udelays that are not
>> needed on virtualized hardware with something else.
>>
>> Just magically defining udelay into nop is broken.
>>     
>
> We'd have to audit and figure out what udelays are for hardware and
> which are not, but the evidence is that the vast majority of them are
> for hardware and not needed for virtualization.
>
> Changing udelay to "hardware_udelay" or something all over the kernel
> would have delayed the paravirt_ops merge by an infinite amount 8)
>   

Yes, so I chose the same approach used for b0rken hardware - #define 
REALLY_SLOW_IO before including headers.  It's ugly, but it works 
without rewriting the entire source base.

Zach
