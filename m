Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbZHQSeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbZHQSeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZHQSeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:34:20 -0400
Received: from www.tglx.de ([62.245.132.106]:43103 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbZHQSeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:34:20 -0400
Date: Mon, 17 Aug 2009 20:34:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: clocksource changes in 2.6.31 - possible regression
In-Reply-To: <20090817112704.2b4b2987@nehalam>
Message-ID: <alpine.LFD.2.00.0908172032500.2782@localhost.localdomain>
References: <20090817090319.20979986@nehalam> <1250531337.26171.12.camel@work-vm> <20090817110127.40ee5c29@nehalam> <1250532954.26171.35.camel@work-vm> <20090817112704.2b4b2987@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009, Stephen Hemminger wrote:
> On Mon, 17 Aug 2009 11:15:54 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> > > > The behavior you describe where you can't switch to the TSC, may be due
> > > > to the TSC disqualification code marking it as non HRT compatible
> > > > (again, I need to double check). While I'm not sure that's really
> > > > correct, as the TSC is fine for HRT, in this case on your box, the TSC
> > > > has been marked as unstable (likely due to being unsynced on old AMD SMP
> > > > systems). There is a real chance that the timekeeping code on your
> > > > system could see the TSC go backwards, calculate a negative time
> > > > interval, and then end up hanging. 
> > > > 
> > > 
> > > TSC was alway stable on this box, and worked fine.  There was no
> > > message in log about TSC instability. The change was bisected
> > > down to that one commit.
> > 
> > But just to clarify, the TSC was never selected as the default
> > clocksource on the box either, right?
> 
> correct.
> 
> I am okay with turning it off on boot command line for my tests,
> but it might be an issue for other users.

Can you please provide a full dmesg of pre 31 and the output of
/sys/.../available_clocksources before you switch to TSC ?

Thanks,

	tglx

