Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYERSKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYERSKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYERSKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:10:12 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41881 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbYERSKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:10:10 -0400
Date: Sun, 18 May 2008 21:08:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
Message-ID: <20080518180811.GI8140@cs181133002.pp.htv.fi>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <482FD9F2.8080204@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <482FD9F2.8080204@goop.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 08:25:38AM +0100, Jeremy Fitzhardinge wrote:
> Thomas Gleixner wrote:
>> Definitely, but we should do it at the Kconfig level which allows us
>> to have integer defines as well, so we end up with something like:
>>
>> static inline unsigned int get_nmi_count(int cpu)
>> {
>>       return CONFIG_X86_64 ? cpu_pda(cpu)->__nmi_count : nmi_count(cpu);
>> }
>>   
>
> Unfortunately that doesn't work because when CONFIG_X86_64 isn't defined  
> it doesn't expand to 0.  It would be nice if CONFIG_* expanded to 0/1,  
> but we'd need to change all the #ifdef CONFIG_* to #if CONFIG_*...

Even more important:
How do you want to handle kconfig variables set to "m"?

Expand them to 0.5 ?  ;-)

>    J

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

