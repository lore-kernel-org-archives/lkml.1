Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbYERSOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbYERSOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYERSNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:13:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33383 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbYERSNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:13:53 -0400
Message-ID: <483071DE.6010404@firstfloor.org>
Date: Sun, 18 May 2008 20:13:50 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <482FD9F2.8080204@goop.org> <20080518180811.GI8140@cs181133002.pp.htv.fi>
In-Reply-To: <20080518180811.GI8140@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, May 18, 2008 at 08:25:38AM +0100, Jeremy Fitzhardinge wrote:
>> Thomas Gleixner wrote:
>>> Definitely, but we should do it at the Kconfig level which allows us
>>> to have integer defines as well, so we end up with something like:
>>>
>>> static inline unsigned int get_nmi_count(int cpu)
>>> {
>>>       return CONFIG_X86_64 ? cpu_pda(cpu)->__nmi_count : nmi_count(cpu);
>>> }
>>>   
>> Unfortunately that doesn't work because when CONFIG_X86_64 isn't defined  
>> it doesn't expand to 0.  It would be nice if CONFIG_* expanded to 0/1,  
>> but we'd need to change all the #ifdef CONFIG_* to #if CONFIG_*...
> 
> Even more important:
> How do you want to handle kconfig variables set to "m"?
> 
> Expand them to 0.5 ?  ;-)

The whole idea was pretty bad. Ifdefs are not ugly because the syntax
looks ugly, but because it's a semantically ugly construct with bad
maintainability impact.

Trying to put syntactical sugar around that is a doomed exercise. It
will be still ugly, no matter what you do.

-Andi

