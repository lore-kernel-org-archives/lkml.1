Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYJaWB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYJaWB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 18:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYJaWBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 18:01:46 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37905 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbYJaWBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 18:01:45 -0400
Subject: Re: next-20081030: voyager compile busted
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <20081030224057.GB20507@elte.hu>
References: <20081030173030.d8847df6.sfr@canb.auug.org.au>
	 <20081030180323.GA13399@x200.localdomain>
	 <1225398287.19324.1.camel@localhost.localdomain>
	 <20081030205230.GO27407@elte.hu>
	 <1225400283.19324.6.camel@localhost.localdomain>
	 <20081030210704.GA25665@elte.hu>
	 <1225401708.19324.35.camel@localhost.localdomain>
	 <490A2A30.5040905@zytor.com>
	 <1225403266.19324.42.camel@localhost.localdomain>
	 <490A2C3D.4020202@zytor.com>  <20081030224057.GB20507@elte.hu>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 12:42:14 -0500
Message-Id: <1225474934.3264.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 23:40 +0100, Ingo Molnar wrote: 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > James Bottomley wrote:
> > > 
> > > Yes ... been having IRC conversations about that.  We'd need to use
> > > runtime patching to fix the performance regressions virtualisation has
> > > been causing us first ... but then we could use it for voyager.
> > 
> > I thought we already were, at least to some degree (the call sites 
> > are way too big and way bigger than they need to be, so we end up 
> > with a lot of NOPs.  I proposed a solution to Jeremy at Kernel 
> > Summit, but he basically said "I don't want to maintain that, I 
> > don't care about hardware performance", which is understandable but 
> > highly unfortunate.)
> 
> in practice the function pointer overhead is almost unmeasurable for 
> things like IPIs which are rather expensive to issue. In fact it's 
> probably more expensive on Voyager as it does not utilize the local 
> APIC for SMP messaging (which is pretty much the only 
> performance-sensitive thing here). It uses its own glue logic it 
> appears, which is almost certainly behind the system bus.

Heh ... don't be so sure:  The VIC uses an array of up to 8 standard
8255 IRQ lines, which is slow.  The QIC uses CPI trigger via cache line
interference, which is far faster than APIC bus based systems (but is
fairly similar to the way SAPIC systems work ... almost a decade after
the original QIC system).

> James, how many cycles do typical SMP ops take on Voyager?

To be honest, I'm not too bothered about that.  What bothers me is that
if a normal system performance goes down because of the function pointer
replacement (remember all x86 SMP systems will see an increase in
function pointer usage because of this approach), then it probably
wasn't worth it.

However, the only way to be sure is to try it and get the benchmarks.

James


