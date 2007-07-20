Return-Path: <linux-kernel-owner+w=401wt.eu-S935015AbXGTHhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935015AbXGTHhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757965AbXGTHh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:37:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51388 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbXGTHh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:37:27 -0400
Date: Fri, 20 Jul 2007 09:37:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Zachary Amsden <zach@vmware.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, jbeulich@novell.com,
       "S. P. Prasanna" <prasanna@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: new text patching for review
Message-ID: <20070720073726.GB19833@one.firstfloor.org>
References: <200707191105.44056.ak@suse.de> <20070719133852.GA5490@Krystal> <200707191546.08919.ak@suse.de> <20070719173502.GB12955@Krystal> <p73d4yow0ys.fsf@bingen.suse.de> <20070719234912.GB30383@Krystal> <46A00CC2.6010407@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A00CC2.6010407@vmware.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 06:15:46PM -0700, Zachary Amsden wrote:
> Mathieu Desnoyers wrote:
> >Yes, kprobes is case 1: atomic update. And we don't even have to bother
> >about Intel's erratum. This one is ok. That's mainly the
> >alternatives/paravirt code I worry about.
> >  
> 
> Paravirt and alternatives should all be ok because they are done before 
> SMP bringup and with NMIs disabled.  NMI watchdog is not setup until 
> smp_prepare_cpus/check_nmi_watchdog, which happens way later, not during 
> parse_args/setup_nmi_watchdog, which just decides which type of watchdog 
> to setup.

There could be other NMIs too - e.g. caused by IO devices or NMI
buttons - but they're relatively unlikely.

> 
> I originally considered the NMI problem for paravirt-ops patching done 
> during module load, and found that I would need to modify 
> stop_machine_run to have an architecture specific callout to mask and 
> unmask NMIs.

When your virtual machine never injects NMIs or MCEs you're ok.

-Andi
