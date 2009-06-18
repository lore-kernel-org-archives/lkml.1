Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbZFRH2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbZFRH2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZFRH2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:28:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44480 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbZFRH17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:27:59 -0400
Date: Thu, 18 Jun 2009 12:57:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frans Pop <elendil@planet.nl>, Subrata Modak <subrata@linux.vnet.ibm.com>,
       "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Sumit Panchasara <sumit.panchasara@einfochips.com>,
       "'Sachin P Sant'" <sachinp@linux.vnet.ibm.com>,
       "'H. Peter Anvin'" <hpa@zytor.com>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH]x86-tsc.c : fix compile warning
Message-ID: <20090618072758.GI22013@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1245247057.3312.2.camel@myhost> <1245248241.4870.12.camel@subratamodak.linux.ibm.com> <20090617152802.GB6042@elte.hu> <200906171812.51478.elendil@planet.nl> <20090617162303.GA10158@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090617162303.GA10158@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2009-06-17 18:23:03]:

> 
> * Frans Pop <elendil@planet.nl> wrote:
> 
> > On Wednesday 17 June 2009, Ingo Molnar wrote:
> > > Ah, and you fixed in what a superior way: you improved the code in
> > > the process :-) This is how warnings should be fixed really.
> > 
> > Hmm. Did you also see Pavel's reply to that patch [1]:
> > ! But that's a bug to be fixed, I'd say? ... actually I believe you are
> > ! introducing a bug here. Yes, old code would put random numbers in
> > ! loops_per_jiffy_ref for !CPUFREQ_CONST_LOOPS, but you are introducing
> > ! oops there.
> > 
> > Was his comment incorrect?
> > 
> > Cheers,
> > FJP
> > 
> > [1] http://lkml.org/lkml/2009/5/24/159
> 
> hm, Pavel seems right - i missed that. Subrata, mind sending an 
> updated patch?
>

Hi, Ingo,

Yes, it does seem that we'll oops at *lpj, but to be honest the code
is badly written, ideally the CONFIG_SMP part should be abstracted
out, having that in a if loop makes reading it time consuming and
kills a few neuro cells each time.
 

-- 
	Balbir
