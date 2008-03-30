Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYC3VIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYC3VIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 17:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYC3VIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 17:08:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54735 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753674AbYC3VIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 17:08:45 -0400
Date: Sun, 30 Mar 2008 16:08:43 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Message-ID: <20080330210843.GB13383@sgi.com>
References: <20080324182122.GA28327@sgi.com> <86802c440803301341i5d116b0en362a51f6d8550482@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803301341i5d116b0en362a51f6d8550482@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   unsigned int get_apic_id(void)
> >   {
> >  -       return (apic_read(APIC_ID) >> 24) & 0xFFu;
> >  +       unsigned int id;
> >  +
> >  +       preempt_disable();
> >  +       id = apic_read(APIC_ID);
> >  +       if (uv_system_type >= UV_X2APIC)
> >  +               id  |= __get_cpu_var(x2apic_extra_bits);
> >  +       else
> >  +               id = (id >> 24) & 0xFFu;;
> >  +       preempt_enable();
> >  +       return id;
> >
> 
> you can not shift id here.
> 
> GET_APIC_ID will shift that again.
> 
> you apic id will be 0 for all cpu
> 

I think this is fixed in the patch that I submitted on Friday. I
had to rework the GET_APIC_ID() changes because of the unification
of -32 & -64 apic code. I think the new code is much cleaner...


--- jack
