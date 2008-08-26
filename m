Return-Path: <linux-kernel-owner+w=401wt.eu-S1758495AbYHZRSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbYHZRSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYHZRS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:18:28 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:47578 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYHZRS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:18:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEACDUs0hMRKxB/2dsb2JhbACBZbcdgWs
Date: Tue, 26 Aug 2008 13:18:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Gerhard Brauer <gerhard.brauer@web.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080826171822.GB14906@Krystal>
References: <20080822113941.147a1db0@doriath.conectiva> <20080822153451.GA8390@Krystal> <20080822132948.57e47076@doriath.conectiva> <20080822163520.GA9860@Krystal> <20080822142054.403cbdef@doriath.conectiva> <20080822175741.6bc83dc8@doriath.conectiva> <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan> <20080826145338.GA8601@Krystal> <20080826131354.356ae11d@doriath.conectiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080826131354.356ae11d@doriath.conectiva>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:15:39 up 82 days, 21:56,  6 users,  load average: 0.12, 0.22,
	0.43
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br) wrote:
> Em Tue, 26 Aug 2008 10:53:38 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> escreveu:
> 
> | Then, after having tested (2), try this on top of it :
> | 
> | In arch/x86/kernel/alternative.c, alternatives_smp_switch()
> | 
> | Add   unsigned long flags;
> | Change 
> | spin_lock -> spin_lock_irqsave(&smp_alt, flags);
> | spin_unlock(&smp_alt); -> spin_unlock_irqrestore(&smp_alt, flags);
> 
>  Hmm, I can't find spin_lock functions in alternatives_smp_switch()
> looks like the current implementation is now using mutexes.
> 

Sorry, I was looking directly at the commit which caused the problem.
Yes, these modif should go on top of the text_poke -> text_poke_early.

So in current mainline, change, in alternatives_smp_switch() :

mutex_lock(&smp_alt);
...

mutex_unlock(&smp_alt);

to

mutex_lock(&smp_alt);
local_irq_save(flags);
...

local_irq_restore(flags);
mutex_unlock(&smp_alt);

Thanks,

Mathieu

>  What tree are you referring to?
> 
> -- 
> Luiz Fernando N. Capitulino

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
