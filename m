Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYIRPwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYIRPwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbYIRPvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:51:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113AbYIRPvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:51:54 -0400
Date: Thu, 18 Sep 2008 11:50:41 -0400
From: Jason Baron <jbaron@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v6
Message-ID: <20080918155041.GB3097@redhat.com>
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <20080917015543.27172da4.akpm@linux-foundation.org> <20080917092732.GB32107@elte.hu> <20080917184618.GB6486@redhat.com> <48D159A7.5080907@zytor.com> <20080918105728.GF20967@elte.hu> <48D2758B.1000004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D2758B.1000004@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 08:36:43AM -0700, H. Peter Anvin wrote:
> Ingo Molnar wrote:
>>
>> which is what we really want. If a bootup fails, the user has to repeat 
>> the bootup at least once with a verbosity level increased and with  
>> (hopefully) some sort of log capture facility attached.
>>
>> So the point would be, if the user specified loglevel=all, we would get 
>> really comprehensive, one-stop-shop output.
>>
>
> That is true if the bootup fails, but it's fairly common that we get the  
> machine up (at least to the point when we can dmesg), but the user wants  
> to report a problem.  For that case, it's very nice if the dmesg log  
> contains as much information as possible.
>
> So I don't think it's clear that pre-filtering is what we want, at all.
>
> 	-hpa
>

hi,

if we take this argument to its extreme, then we end up spending all of
our time verifying that the kernel is working correctly and no time
actually doing work. I think 'printk_ratelimit' captures this. Thus, the line 
has to be drawn somewhere. If you want the messages in 'dmesg' use,
printk(KERN_DEBUG), and 'grep'. For the rest, I propose pre-filtering, which is
what 'dynamic debug' uses.

thanks,

-Jason
