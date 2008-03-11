Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbYCKXsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbYCKXsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYCKXrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:47:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123AbYCKXrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:47:53 -0400
Date: Tue, 11 Mar 2008 16:47:21 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Nicholas Miell <nmiell@comcast.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Message-ID: <20080311164721.1d0a5654@extreme>
In-Reply-To: <1205277132.12854.19.camel@entropy>
References: <200803111749.29143.nickpiggin@yahoo.com.au>
	<1205269674.12854.16.camel@entropy>
	<47D6FAD0.1020608@gmx.net>
	<1205277132.12854.19.camel@entropy>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 16:12:12 -0700
Nicholas Miell <nmiell@comcast.net> wrote:

> 
> On Tue, 2008-03-11 at 22:34 +0100, Cyrus Massoumi wrote:
> > Nicholas Miell wrote:
> >
> > > (Also, ignoring MySQL because it's a terrible piece of software at least
> > > when regarding it's scalability is a bad idea. It's the M in LAMP, it
> > > has a huge user base, and FreeBSD manages to outperform Linux with the
> > > same unscalable piece of software.)
> > 
> > Did you actually see this? 
> > http://www.kernel.org/pub/linux/kernel/people/npiggin/sysbench/
> > 
> > FreeBSD does not outperform Linux, it's actually a bit faster according 
> > to Nick's tests.
> 
> I am aware of those results, but in the mail I was responding to, Nick
> Piggin said the following:
> 
> > The problem with MySQL contention means that if the scheduler
> > unluckily chooses to deschedule a lock holder, then you can get
> > idle time building up on other cores and you can get context switch
> > cascades as things all pile up onto this heavily contended lock. As
> > such, it means MySQL is not an ideal candidate for looking at
> > performance behaviour. I discounted the relatively worse scaling of
> > MySQL with 2.6.25-rc (than 2.6.22) as such an effect.
> 
> which I interpreted to mean that MySQL performs worse on 2.6.23+ than on
> 2.6.22 but for some reason this doesn't matter.
> 

How many of these problems are due to poorly implemented userlevel
spinlocks?  Do the database spinlocks map to futexes?
