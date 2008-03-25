Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbYCYQbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbYCYQbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbYCYQbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:31:08 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37417 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755066AbYCYQbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:31:06 -0400
Date: Tue, 25 Mar 2008 11:31:03 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Message-ID: <20080325163103.GA2651@sgi.com>
References: <20080324182122.GA28327@sgi.com> <20080325143059.GB11323@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325143059.GB11323@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 03:30:59PM +0100, Ingo Molnar wrote:
> 
> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > Index: linux/arch/x86/kernel/genapic_64.c
> 
> > @@ -69,7 +73,16 @@ void send_IPI_self(int vector)
> >  
> >  unsigned int get_apic_id(void)
> >  {
> > -	return (apic_read(APIC_ID) >> 24) & 0xFFu;
> > +	unsigned int id;
> > +
> > +	preempt_disable();
> > +	id = apic_read(APIC_ID);
> > +	if (uv_system_type >= UV_X2APIC)
> > +		id  |= __get_cpu_var(x2apic_extra_bits);
> > +	else
> > +		id = (id >> 24) & 0xFFu;;
> > +	preempt_enable();
> > +	return id;
> 
> dont we want to put get_apic_id() into struct genapic instead? We 
> already have ID management there.
> 
> also, we want to unify 32-bit and 64-bit genapic code and just have 
> genapic all across x86.

Long term, I think that makes sense. However, I think that should be a
separate series of patches since there are significant differences between
the 32-bit and 64-bit genapic structs.

--- jack
