Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYGGLxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYGGLxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYGGLxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:53:25 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:47971 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752678AbYGGLxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:53:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LFl0dnRKpT+4vECtEJysJk+hHnnWLS9zhdRudVpN68g2/U5DrsePeVCYDZ6fkAJSJG4ScG15oQ7flUCWK7mPqCybX3COOCR/E1Ac+ICvk1J5OIxDQSrYk5CinmQz3DXSgVDDQ2Pd8w51gQT6qY7ROxlMZP48Q7SFvkWzvxb4q1A=  ;
X-YMail-OSG: sfwRoGUVM1lTccOtL9OGm2H3AV6_LWFc9NiBDn8ptDm2fXrI3Q1Oc_HX4cNSrsxFT03w6Vy0_nbwIJzbVkil3q9DzaseYUfUs61Mz43tcw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin with irqs disable
Date: Mon, 7 Jul 2008 21:52:59 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> <48630420.1090102@goop.org> <200807072150.39571.nickpiggin@yahoo.com.au>
In-Reply-To: <200807072150.39571.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072152.59823.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2008 21:50, Nick Piggin wrote:
> On Thursday 26 June 2008 12:51, Jeremy Fitzhardinge wrote:

> > Thomas Friebel presented results at the Xen Summit this week showing
> > that ticket locks are an absolute disaster for scalability in a virtual
> > environment, for a similar reason.  It's a bit irritating if the lock
> > holder vcpu gets preempted by the hypervisor, but its much worse when
> > they release the lock: unless the vcpu scheduler gives a cpu to the vcpu
> > with the next ticket, it can waste up to N timeslices spinning.
>
> I didn't realise it is good practice to run multiple "virtual CPUs"
> of the same guest on a single physical CPU on the host...
>
> > I'm experimenting with adding pvops hook to allow you to put in new
> > spinlock implementations on the fly.  If nothing else, it will be useful
> > for experimenting with different algorithms.  But it definitely seems
> > like the old unfair lock algorithm played much better with a virtual
> > environment, because the next cpu to get the lock is the next one the
> > scheduler gives time, rather than dictating an order - and the scheduler
> > should mitigate the unfairness that ticket locks were designed to solve.
>
> ... if it is good practice, then, virtualizing spinlocks I guess is
> reasonable. If not, then "don't do that". Considering that probably
> many bare metal systems will run pv kernels, every little cost adds
> up.

Although, you wouldn't need to oversubscribe physical CPUs to hit
suboptimal behaviour.

Basically, I just ask for performance improvement to be measured
with some "realistic" configuration, then it should be easier to
justify.
