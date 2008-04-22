Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbYDVRui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbYDVRui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYDVRu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:50:26 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:51423 "EHLO
	QMTA06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914AbYDVRu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:50:26 -0400
X-Authority-Analysis: v=1.0 c=1 a=wJU8NHEZH4cA:10 a=QJ678JVvaQ4A:10
 a=fwGX1p_QAU-OivjuRIYA:9 a=ERhA6toDVfr9nUipIym-XQR4QNQA:4 a=si9q_4b84H0A:10
 a=WuK_CZDBSqoA:10
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
From: Nicholas Miell <nmiell@comcast.net>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       mathieu.desnoyers@polymtl.ca
In-Reply-To: <20080419184836.GB29968@redhat.com>
References: <20080415115314.GA6975@in.ibm.com>
	 <1208260942.6395.6.camel@twins> <20080415155223.GA6935@in.ibm.com>
	 <1208361092.6395.81.camel@twins> <y0m1w54cf82.fsf@ton.toronto.redhat.com>
	 <1208501204.7115.60.camel@twins> <20080418142949.GB3922@redhat.com>
	 <1208616747.6452.3.camel@lappy> <20080419180306.GA29968@redhat.com>
	 <1208629769.6452.23.camel@lappy>  <20080419184836.GB29968@redhat.com>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 10:50:00 -0700
Message-Id: <1208886600.2407.4.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-04-19 at 14:48 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Sat, Apr 19, 2008 at 08:29:27PM +0200, Peter Zijlstra wrote:
> > [...]
> > > OTOH I think this is a false dichotomy.  Debugging is not only done by
> > > a subsystem maintainer during the merge/rc period.  When something
> > > goes wrong on a deployed machine, problem diagnosis requires data,
> > > which ideally should be gathered as non-intrusively as possible - that
> > > means no recompiling / rebooting, and ideally very little slowdown.
> > > [...]
> 
> > This again tries into the argument about not making markers depend on
> > the code structure or implementation details.
> 
> It should not *unnecessarily* depend on those.
> 
> > I'm really wanting to avoid ever having to be obstructed by a marker. So
> > any marker that does not represent a solid high level event (to take
> > Mathieu's example: a context switch is a context switch, and we'll
> > always have one) I'm not comfortable with merging that upstream.
> 
> It is your prerogative as a subsystem maintainer to make a guess about
> this.  Others may make their own decisions differently, considering
> the small costs and potential benefits.
> 
> > So even though these ad-hoc markers might have some diagnostic value
> > - I'll never support merging them. If a customer might have some
> > issue I can hand him a custom kernel with these markers added in - I
> > see absolutely no reason to burden upstream with these.
> 
> Perhaps the kinds of bugs in your code, coupled with the kinds of
> customers who experience those bugs, make tolerable this means of
> diagnosis (requiring a reboot of their machines into a custom
> debugging kernel).  The customers I have dealt with (and frankly, I
> too) need to diagnose problems on a live running system as much as
> possible.  They don't run every kernel du jour, so they don't need the
> purely hypothetical tools that are dependent on a permanent set of
> markers.
>  

Sun solved this problem for DTrace by applying their stability
attributes to all probe points -- i.e. the probes that represent an ABI
are marked as such and the temporary debugging probes are marked as
unstable.

-- 
Nicholas Miell <nmiell@comcast.net>

