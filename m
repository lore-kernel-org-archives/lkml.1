Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbXKTPhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbXKTPhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760051AbXKTPhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:37:32 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:48200 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760005AbXKTPhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:37:31 -0500
Date: Tue, 20 Nov 2007 07:37:28 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, ak@suse.de,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org
Subject: Re: [patch][v2] x86, ptrace: support for branch trace store(BTS)
In-Reply-To: <alpine.DEB.0.99999.0711200708580.765@twinlark.arctic.org>
Message-ID: <alpine.DEB.0.99999.0711200729570.765@twinlark.arctic.org>
References: <029E5BE7F699594398CA44E3DDF55444F3AEA7@swsmsx413.ger.corp.intel.com> <alpine.DEB.0.99999.0711200708580.765@twinlark.arctic.org>
User-Agent: Alpine 0.99999 (DEB 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, dean gaudet wrote:

> On Tue, 20 Nov 2007, Metzger, Markus T wrote:
> 
> > +__cpuinit void ptrace_bts_init_intel(struct cpuinfo_x86 *c)
> > +{
> > +	switch (c->x86) {
> > +	case 0x6:
> > +		switch (c->x86_model) {
> > +#ifdef __i386__
> > +		case 0xD:
> > +		case 0xE: /* Pentium M */
> > +			ptrace_bts_ops = ptrace_bts_ops_pentium_m;
> > +			break;
> > +#endif /* _i386_ */
> > +		case 0xF: /* Core2 */
> > +			ptrace_bts_ops = ptrace_bts_ops_core2;
> > +			break;
> > +		default:
> > +			/* sorry, don't know about them */
> > +			break;
> > +		}
> > +		break;
> > +	case 0xF:
> > +		switch (c->x86_model) {
> > +#ifdef __i386__
> > +		case 0x0:
> > +		case 0x1:
> > +		case 0x2:
> > +		case 0x3: /* Netburst */
> > +			ptrace_bts_ops = ptrace_bts_ops_netburst;
> > +			break;
> > +#endif /* _i386_ */
> > +		default:
> > +			/* sorry, don't know about them */
> > +			break;
> > +		}
> > +		break;
> 
> is this right?  i thought intel family 15 models 3 and 4 supported amd64
> mode...

actually... why aren't you using cpuid level 1 edx bit 21 to 
enable/disable this feature?  isn't that the bit defined to indicate 
whether this feature is supported or not?

and it seems like this patch and perfmon2 are going to have to live with 
each other... since they both require the use of the DS save area...

-dean
