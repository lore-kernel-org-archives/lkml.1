Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYIRP6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYIRP6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYIRP6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:58:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45910 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYIRP6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:58:32 -0400
Message-ID: <48D27A7E.8090403@zytor.com>
Date: Thu, 18 Sep 2008 08:57:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v6
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <20080917015543.27172da4.akpm@linux-foundation.org> <20080917092732.GB32107@elte.hu> <20080917184618.GB6486@redhat.com> <48D159A7.5080907@zytor.com> <20080918105728.GF20967@elte.hu> <48D2758B.1000004@zytor.com> <20080918155041.GB3097@redhat.com>
In-Reply-To: <20080918155041.GB3097@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> 
> if we take this argument to its extreme, then we end up spending all of
> our time verifying that the kernel is working correctly and no time
> actually doing work. I think 'printk_ratelimit' captures this. Thus, the line 
> has to be drawn somewhere. If you want the messages in 'dmesg' use,
> printk(KERN_DEBUG), and 'grep'. For the rest, I propose pre-filtering, which is
> what 'dynamic debug' uses.
> 

Taking any argument to its extreme and you come up with something 
ridiculous.

One could equally argue that if you have so many debugging messages that 
you have to prefilter for performance, you're so bloating your kernel 
that you need to stop.

I find it highly questionable that it makes sense to put even skipped 
messages into hot paths in the production kernel.  Skipped prints are 
NOT free, even if they are lot cheaper than actually rendering the string.

	-hpa
