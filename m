Return-Path: <linux-kernel-owner+w=401wt.eu-S1763521AbXJFRzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763521AbXJFRzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 13:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759507AbXJFRzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 13:55:31 -0400
Received: from barikada.upol.cz ([158.194.242.200]:44363 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760693AbXJFRz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 13:55:29 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>, Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
In-Reply-To: <20071006110835.GA24463@elte.hu>
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr> <20071006110835.GA24463@elte.hu>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Sat, 6 Oct 2007 20:09:31 +0200
Message-Id: <E1IeE5j-0005a6-10@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sat, 6 Oct 2007 13:08:35 +0200

> * Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
>> Colored kernel message output
>> 
>> Let's work more on Linux's cuteness! 
>> [http://lkml.org/lkml/2007/10/4/431] The following patch makes it 
>> possible to give kernel messages a selectable color

Only boot time selectable? Then write so, please.

>> which helps to distinguish it from other noise, such as boot messages.
>> NetBSD has it, OpenBSD has it, FreeBSD to some extent, so I think
>> Linux should too.

This approach in GIGO-like, IMHO. Ugliness of (default) boot process
messaging itself can and must be solved in the userspace. I don't know if
anybody read sub-thread about size reduction by moving static printk
string to userspace "message codes" (there were one more person than me,
but still).

The main problem, is the very narrow perspective of such "kernel"
functionality:

> feature request: would be interesting to have a color table (defined in 
> the .config) dependent on message loglevel. That way KERN_CRIT messages 
> could be red, KERN_INFO ones white, etc.
>
> 	Ingo

See? In the userspace one can make anything freely, try do it in the
Linux kernel. With userspace {codes, messages} -> messages tool, any
console printing frontend is possible. Of course, when kernel OOPes
before or in early userspace, where nothing other than photo viva is
possible, nobody should care about "Linux's cuteness!"

>> Inspired by cko (http://freshmeat.net/p/cko/), but independently
>> written, later contributed forth and back.
>> 
>> Already posted at: http://lkml.org/lkml/2007/4/1/162
>> 
>> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
>
> looks really good to me!
>
> Reviewed-by: Ingo Molnar <mingo@elte.hu>
>
> small nit:
>
> +       vc->vc_color = printk_color;
> +       update_attr(vc);
>
> that should be in a set_vc_color() function and the new code should do:
>
> +	set_vc_color(vc, vc->vc_color);
>
> (and same at the other places that call update_attr() as well)

Is it possible to have a macro for this, which will be
`do { } while(0)' in case of "NO, thanks" configuration?

--
-o--=O`C
 #oo'L O
<___=E M
