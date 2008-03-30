Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYC3XYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYC3XYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYC3XYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:24:30 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:50586 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYC3XY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:24:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O2ZsUJm7/dijMoIVi/vEfPXCXAEpyEgiGIE21Z5Z4nfiDEaeVxGGrK3f7HFw41Uc54agpmbS4jKqJkx+iX5Y3IOeVw6IHtgPPHBUctPp6dLHkYz8DAIgudxiKioYrlJN+2XqvDhpygyqxcey0kwm8mXi2MUEKk+8fMjyQtKUlkQ=
Message-ID: <86802c440803301624r4601eae2g5bacc54f69c032db@mail.gmail.com>
Date: Sun, 30 Mar 2008 16:24:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Steiner" <steiner@sgi.com>
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Cc: mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080330210843.GB13383@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080324182122.GA28327@sgi.com>
	 <86802c440803301341i5d116b0en362a51f6d8550482@mail.gmail.com>
	 <20080330210843.GB13383@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 2:08 PM, Jack Steiner <steiner@sgi.com> wrote:
> > >   unsigned int get_apic_id(void)
>  > >   {
>  > >  -       return (apic_read(APIC_ID) >> 24) & 0xFFu;
>  > >  +       unsigned int id;
>  > >  +
>  > >  +       preempt_disable();
>  > >  +       id = apic_read(APIC_ID);
>  > >  +       if (uv_system_type >= UV_X2APIC)
>  > >  +               id  |= __get_cpu_var(x2apic_extra_bits);
>  > >  +       else
>  > >  +               id = (id >> 24) & 0xFFu;;
>  > >  +       preempt_enable();
>  > >  +       return id;
>  > >
>  >
>  > you can not shift id here.
>  >
>  > GET_APIC_ID will shift that again.
>  >
>  > you apic id will be 0 for all cpu
>  >
>
>  I think this is fixed in the patch that I submitted on Friday. I
>  had to rework the GET_APIC_ID() changes because of the unification
>  of -32 & -64 apic code. I think the new code is much cleaner...

i think Ingo already put you Friday's version in x86.git#latest.

that is wrong too with extra shift.

YH
