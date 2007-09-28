Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbXI1U64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbXI1U64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbXI1U6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:58:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:58762 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbXI1U6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:58:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aXZXIOsLR1NK37WrAMrXiITKEPcO4g1zi1PsZ8PnSuW1VYxkAsUpdB5rgyQ4XVPF8jwnfE3ce+Xj1Ipqx3ak5xT2UETQmXAWHQ4OYj/EjwlK2chGy/y/xH8cZWyxAJ4sc8iBa9O25a+9TsYWuuAjK6SePqFsMuUl3NsAEED1Ic4=
Message-ID: <cfd9edbf0709281358k3f6307e8h4d2c131378645747@mail.gmail.com>
Date: Fri, 28 Sep 2007 22:58:46 +0200
From: "=?ISO-8859-1?Q?Daniel_Sp=E5ng?=" <daniel.spang@gmail.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: Out of memory management in embedded systems
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0709281105340.9420@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com>
	 <Pine.LNX.4.61.0709280857520.8940@chaos.analogic.com>
	 <cfd9edbf0709280630x7396e49fi523e1d58aab9458a@mail.gmail.com>
	 <Pine.LNX.4.61.0709281000300.9062@chaos.analogic.com>
	 <cfd9edbf0709280714u7a03ec16pfe3cb7328dbab7ad@mail.gmail.com>
	 <Pine.LNX.4.61.0709281105340.9420@chaos.analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>
> On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:
>
> > On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> >>
> >> On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:
> >>
> >>> On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> >>>>
> >>>> But an embedded system contains all the software that will
> >>>> ever be executed on that system! If it is properly designed,
> >>>> it can never run out of memory because everything it will
> >>>> ever do is known at design time.
> >>>
> >>> Not if its input is not known beforehand. Take a browser in a mobile
> >>> phone as an example, it does not know at design time how big the web
> >>> pages are. On the other hand we want to use as much memory as
> >>> possible, for cache etc., a method that involves the kernel would
> >>> simplify this and avoids setting manual limits.
> >>>
> >>> Daniel
> >>>
> >>
> >> Any networked appliance can (will) throw data away if there are
> >> no resources available.
> >>
> >> The length of a web-page is not relevent, nor is the length
> >> of any external data. Your example will buffer whatever it
> >> can and not read anything more from the external source until
> >> it has resources available unless it is broken.
> >
> > And how do you determine when no resources are availabe? We are using
> > overcommit here so malloc() will always return non null.
> >
>
> A networked appliance using embedded software is not your daddy's
> Chevrolet. Any task that is permanent needs to allocate all its
> resources when it starts. That's how it knows how much there are,
> and incidentally, it doesn't do it blindly. The system designer
> must know how much memory is available in the system and how much
> is allocated to the kernel.
>
> The fact that you can give a fictitious value to malloc() is not
> relevant. If you don't provide resources for malloc(), like
> (ultimately) a swap file, then you can't assume that it can do
> any design work for you.
>
> An embedded system is NOT an ordinary system that happens to
> boot from flash. An embedded system requires intelligent design.

We might be talking about slightly different systems. I agree that
systems that are really embedded, in the classic meaning often with
real time constraints, should be designed as you suggests. But there
are a lot of other systems that almost actually are ordinary systems
but with limited memory and often without demand paging. This could be
a set top box, a  video game console or a mobile phone that run
dynamic applications.

Actually this is not only about applications allocating an unknown
amount of dynamic memory. A similar situation could also appear when
we run an unknown number of applications at once, each allocating just
a static amount of memory and then later starts to touching it.

For those systems I think we need a method to dynamically decrease the
working set of a process when memory is scarce, and not just accept
that we "are screwed" and let the OOM killer solve the problem.
