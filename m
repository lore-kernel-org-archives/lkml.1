Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbYLHLz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbYLHLz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbYLHLuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:50:50 -0500
Received: from ozlabs.org ([203.10.76.45]:58578 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492AbYLHLus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:50:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 2/2] kvm: use cpumask_var_t for cpus_hardware_enabled
Date: Mon, 8 Dec 2008 22:20:42 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: "kvm-devel" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <200812072125.45757.rusty@rustcorp.com.au> <200812081635.35166.rusty@rustcorp.com.au> <493CED04.6020209@redhat.com>
In-Reply-To: <493CED04.6020209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812082220.42790.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2008 20:16:44 Avi Kivity wrote:
> Rusty Russell wrote:
> >> This isn't on stack, so it isn't buying us anything.
> >>     
> >
> > It's the CONFIG_NR_CPUS=4096 but nr_cpu_ids=4 case which we win using
> > dynamic allocation.  Gotta love distribution kernels.
> >
> >   
> 
> What does it buy? 4096/8 = 512 bytes statically allocated?

It adds up, and 4096 seems to be only the start of the insanityH^H^Hfun.

> > Not quite.  If !CONFIG_CPUMASK_OFFSTACK, cpumask_var_t == cpumask_t[1].
> > Blame Linus :)
> >   
> 
> Hm, is there a C trick which will error out when allocating something on 
> the stack, but work when allocating statically?  I can think of 
> something to do the reverse, but that doesn't help.

We also need to prevent assignment, eg:

	*foo = *bar;

Because when we allocate them, we'll cut them to size.

Cheers,
Rusty.
