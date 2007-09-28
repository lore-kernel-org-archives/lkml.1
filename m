Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbXI2MpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbXI2MpB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 08:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbXI2Mov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 08:44:51 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:22036 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750788AbXI2Mou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 08:44:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jL9+73NMraJHmUTkL3IUxJfKYU/kfKoihm++K6VuU2LCpCx0cKoaWd1mRL4XKF6RMxaLzJD1yCPZpn9G/85tkyBqoe0HEFSxtUij9CO+A85Glt7dsw/dfTsGso0P0sTz9aM4vsHmuWgqaLczT07mOiUtR8t3dNOkAv3oyLi/XIY=  ;
X-YMail-OSG: 29r5RTIVM1kDfdEuyVzxOVohjo4YWq8L7lrfepCB9ojfvw7kO6O1HBqilzxZC3IvKsh7s9Vn_oWz5UckgWdR0J1R_wBtrFxnfODEcGzuNB_DG81GbkQ-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jarek Poplawski <jarkao2@o2.pl>
Subject: Re: Network slowdown due to CFS
Date: Fri, 28 Sep 2007 16:10:00 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, David Schwartz <davids@webmaster.com>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
References: <20070926133138.GA23187@elte.hu> <20070927133123.GA6901@elte.hu> <20070927144228.GC2431@ff.dom.local>
In-Reply-To: <20070927144228.GC2431@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281610.00682.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2007 00:42, Jarek Poplawski wrote:
> On Thu, Sep 27, 2007 at 03:31:23PM +0200, Ingo Molnar wrote:
> > * Jarek Poplawski <jarkao2@o2.pl> wrote:
>
> ...
>
> > > OK, but let's forget about fixing iperf. Probably I got this wrong,
> > > but I've thought this "bad" iperf patch was tested on a few nixes and
> > > linux was the most different one. The main point is: even if there is
> > > no standard here, it should be a common interest to try to not differ
> > > too much at least. So, it's not about exactness, but 50% (63 -> 95)
> > > change in linux own 'definition' after upgrading seems to be a lot.
> > > So, IMHO, maybe some 'compatibility' test could be prepared to compare
> > > a few different ideas on this yield and some average value could be a
> > > kind of at least linux' own standard, which should be emulated within
> > > some limits by next kernels?
> >
> > you repeat your point of "emulating yield", and i can only repeat my
> > point that you should please read this:
> >
> >     http://lkml.org/lkml/2007/9/19/357
> >
> > because, once you read that, i think you'll agree with me that what you
> > say is simply not possible in a sane way at this stage. We went through
> > a number of yield implementations already and each will change behavior
> > for _some_ category of apps. So right now we offer two implementations,
> > and the default was chosen empirically to minimize the amount of
> > complaints. (but it's not possible to eliminate them altogether, for the
> > reasons outlined above - hence the switch.)
>
> Sorry, but I think you got me wrong: I didn't mean emulation of any
> implementation, but probably the some thing you write above: emulation
> of time/performance. In my opinion this should be done experimentally
> too, but with something more objective and constant than current
> "complaints counter". And the first thing could be a try to set some
> kind of linux internal "standard of yeld" for the future by averaging
> a few most popular systems in a test doing things like this iperf or
> preferably more.

By definition, yield is essentially undefined as to the behaviour between
SCHED_OTHER tasks at the same priority level (ie. all of them), because
SCHED_OTHER scheduling behaviour itself is undefined.

It's never going to do exactly what everybody wants, except those using
it for legitimate reasons in realtime applications.
