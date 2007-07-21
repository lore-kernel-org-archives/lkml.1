Return-Path: <linux-kernel-owner+w=401wt.eu-S933664AbXGUGTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664AbXGUGTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbXGUGTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:19:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48355 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbXGUGTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:19:46 -0400
Date: Sat, 21 Jul 2007 08:19:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Zachary Amsden <zach@vmware.com>, Andi Kleen <andi@firstfloor.org>,
       jbeulich@novell.com, "S. P. Prasanna" <prasanna@in.ibm.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: new text patching for review
Message-ID: <20070721061945.GC5293@one.firstfloor.org>
References: <200707191105.44056.ak@suse.de> <20070719133852.GA5490@Krystal> <200707191546.08919.ak@suse.de> <20070719173502.GB12955@Krystal> <p73d4yow0ys.fsf@bingen.suse.de> <20070719234912.GB30383@Krystal> <46A00CC2.6010407@vmware.com> <20070720151748.GA511@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720151748.GA511@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 11:17:49AM -0400, Mathieu Desnoyers wrote:
> * Zachary Amsden (zach@vmware.com) wrote:
> > Mathieu Desnoyers wrote:
> > >Yes, kprobes is case 1: atomic update. And we don't even have to bother
> > >about Intel's erratum. This one is ok. That's mainly the
> > >alternatives/paravirt code I worry about.
> > >  
> > 
> > Paravirt and alternatives should all be ok because they are done before 
> > SMP bringup and with NMIs disabled.  NMI watchdog is not setup until 
> > smp_prepare_cpus/check_nmi_watchdog, which happens way later, not during 
> > parse_args/setup_nmi_watchdog, which just decides which type of watchdog 
> > to setup.
> > 
> 
> I'm not so sure about this. You are right in that it has nothing to do
> with parse_args, but I just went in detail through the source, and the
> order seems to be:
> 
> 1 - NMI is activated
> 2 - MCE is activated
> 3 - alternatives are applied

Yes I was wrong on this. I now added code to disable them again -- see 
the later patch I posted

-Andi
