Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbZCIUyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbZCIUyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZCIUyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:54:33 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:39082 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZCIUyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:54:33 -0400
Message-ID: <49B581FB.7060506@freescale.com>
Date: Mon, 09 Mar 2009 15:54:19 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, rdreier@cisco.com, peterz@infradead.org,
       will.newton@gmail.com
Subject: Re: [PATCH v3] add function spin_event_timeout()
References: <1236630740-22024-1-git-send-email-timur@freescale.com> <49B57F45.7040104@gmail.com>
In-Reply-To: <49B57F45.7040104@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 9.3.2009 21:32, Timur Tabi wrote:
>> +#define spin_event_timeout(condition, timeout)				\
>> +({									\
>> +	int __timeout = timeout;					\
>> +	while (!(condition)&&  --__timeout) {				\
>> +		udelay(1);						\
>> +		cpu_relax();						\
> 
> So you don't need cpu_relax anymore...

I checked the udelay() code.  It varies per platform, but I didn't see
how it always replicated the functionality of cpu_relax().  For example,
in x86_64, cpu_relax is a "rep; nop;".  But I don't see that code
sequence in arch/x86/lib/delay.c.

So I presume that something in the delay functions makes cpu_relax()
unnecessary.  What exactly is the purpose of cpu_relax()?

> And I would make timeout UL like delay functions.

I made it an integer because I don't expect anyone to pass a value
larger than 2^31, but I'll change it.

-- 
Timur Tabi
Linux kernel developer at Freescale
