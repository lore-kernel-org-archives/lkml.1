Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYH1BHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYH1BHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYH1BHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:07:30 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:20155 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753065AbYH1BH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:07:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1uoWnfphAkLwJYlz+lYS+XF17hXVgG1V1p0HhIoUig+Ca6glMovsN6L6P4CJp7yrqII6LbYwHCG5Ia1JKAAfFRhr3lUAtfHSlJNKOxv8XDBpVAaMDJ/2ayTFG1baIUlCm5xwAoFt+CPtim1bIH415KFVYqRC4i2PrOopnJOnxbg=  ;
X-YMail-OSG: U3Q4.T4VM1mLkmnkBVUFB5fFnRzcoLrd3i3gVQwVZAALEgjSzh2V4Vekzw1aJ_K8ZC6Uj7jhuEDlnIHmJeup8Ey99mrodTj06MaJq_k2Dy2VZ..6zthAXQpkUJp0OU5AmOOwtHWi7hGuDJR9vUKAFPc9
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Date: Thu, 28 Aug 2008 11:07:20 +1000
User-Agent: KMail/1.9.5
Cc: andi@firstfloor.org, rick.jones2@hp.com, johnpol@2ka.mipt.ru,
       dada1@cosmosbay.com, denys@visp.net.lb, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080827.151824.14173512.davem@davemloft.net> <200808281045.03460.nickpiggin@yahoo.com.au> <20080827.174855.126675086.davem@davemloft.net>
In-Reply-To: <20080827.174855.126675086.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281107.21173.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008 10:48, David Miller wrote:
> From: Nick Piggin <nickpiggin@yahoo.com.au>
> Date: Thu, 28 Aug 2008 10:45:03 +1000
>
> > On Thursday 28 August 2008 08:39, Andi Kleen wrote:
> > > On Wed, Aug 27, 2008 at 03:18:24PM -0700, David Miller wrote:
> > > > From: Andi Kleen <andi@firstfloor.org>
> > > > Date: Wed, 27 Aug 2008 18:27:35 +0200
> > > >
> > > > > > Those banks really want to crank down on latency - to the point
> > > > > > they start disabling interrupt coalescing.  I bet they'd toss
> > > > > > anything out they could to shave another microsecond.
> > > > >
> > > > > This change would actually likely lower their latency.
> > > >
> > > > They want the timestamps, but they want it to match when the packet
> > > > arrived at their system as closely as is reasonably possible.
> > >
> > > Then they should use hardware time stamps which are increasingly
> > > available (e.g. current Intel e1000 design has them and I expect
> > > others too).
> >
> > Would it make sense to make a new option for these socket timestamps
> > and encourage some apps move over to it?
>
> We don't have support to using these specific hardware provided timestamps
> sources yet, so it's kind of premature to recommend the facility to
> applications. :)

Dang, that was a really badly quoted. I was reading the thread and
got to the end and just fired off my reply from there...

Sorry -- what I meant to ask was, would it make sense to have a new
option to enable time stamp measuring in the socket receive layer
as in the patchset that Andi referenced, but without removing existing
support for early timestamping?

