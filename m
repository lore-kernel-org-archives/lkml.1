Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYHVNn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYHVNn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 09:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbYHVNnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 09:43:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:32286 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYHVNno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 09:43:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M0HbYVPkOvXMuw3ZY9xF5YYiQBSWbi9VuHhkRLc/+9YeB4KuG50mZze+ldCyvrjuKE
         rsl6X0tB7/qXAI4XqCOQc56GQEsWWbhwwJAEJX9NlCX7jMum9r5RjW6M1lUCoTV214gc
         E/kRF76dpkdMSnXWK0InrNJmYz4ZSZXYGllJE=
Date: Fri, 22 Aug 2008 17:44:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alex Nixon <alex.nixon@citrix.com>, Alan Mayer <ajm@sgi.com>
Subject: Re: [PATCH] x86: fix probe_nr_irqs for xen
Message-ID: <20080822134410.GA7351@lenovo>
References: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com> <48ADFB33.8010204@goop.org> <86802c440808211649h37ac7533q4b95a83306ecd430@mail.gmail.com> <48ADFFD2.7030309@goop.org> <86802c440808211656o20f9a22dv34e3ac8e8e84b4e1@mail.gmail.com> <48AE022F.6030100@goop.org> <20080822042610.GA15212@elte.hu> <86802c440808212206s66c31203n651ca021c01104ca@mail.gmail.com> <20080822051656.GA7696@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822051656.GA7696@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, Aug 22, 2008 at 07:16:56AM +0200]
| 
| * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
| 
| > > But by all means SPARSEIRQ is the primary and only model on x86.
| > >
| > > We could even plug in the dynamic vector allocator from Alan Mayer 
| > > now, both on 32-bit and on 64-bit x86: Yinghai, any complications 
| > > expected there? I guess we need to unify the local APIC code first.
| > 
| > apic_32.c and apic_64.c
| > irqinit_32.c and irqinit_64.c
| > irq_32.c and irq_64.c
| > 
| > Cyrill, is still working on merging apic_32.c apic_64.c.?
| 
| there's a few weeks of inactivity expected in that area i think - so if 
| you'd like to pick it up from there, feel free ...
| 
| but apic_32/64.c is looking already pretty good in tip/master:
| 
|  1 file changed, 391 insertions(+), 358 deletions(-)
| 
| the most significant bit of that delta seems to be around x2apic, 
| calibration differences and some older 32-bit legacies which are not on 
| the 64-bit side (but which we can add safely).
| 
| 	Ingo
| 

Yes - I will be busy for a few weeks with other duties, sorry for
that. There not that much diff rest:

- apic clock calibration
- x2apic operations
- interrupt handlers (different declarations)
- command line handling

ugh... maybe not that small heap of todo's :)

Anyway - before sending patches I'll fetch tip/x86/apic
branch so no problem if someone bring any changes into
the branch.

		- Cyrill -
