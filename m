Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbYGGTr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbYGGTr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbYGGTrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:47:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbYGGTrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:47:18 -0400
Date: Mon, 7 Jul 2008 15:46:51 -0400
From: Rik van Riel <riel@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
 with irqs disable
Message-ID: <20080707154651.35d1004c@cuia.bos.redhat.com>
In-Reply-To: <48630420.1090102@goop.org>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
	<20080507073017.GJ32195@elte.hu>
	<Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>
	<1214241561.19392.21.camel@elijah.suse.cz>
	<Pine.LNX.4.64.0806231115420.22557@schroedinger.engr.sgi.com>
	<1214253593.11254.30.camel@twins>
	<Pine.LNX.4.64.0806231345001.28304@schroedinger.engr.sgi.com>
	<1214254730.11254.34.camel@twins>
	<48630420.1090102@goop.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 19:51:12 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Thomas Friebel presented results at the Xen Summit this week showing 
> that ticket locks are an absolute disaster for scalability in a virtual 
> environment, for a similar reason.  It's a bit irritating if the lock 
> holder vcpu gets preempted by the hypervisor, but its much worse when 
> they release the lock: unless the vcpu scheduler gives a cpu to the vcpu 
> with the next ticket, it can waste up to N timeslices spinning.
> 
> I'm experimenting with adding pvops hook to allow you to put in new 
> spinlock implementations on the fly.

Alternatively, the guest could tell the host which vcpus
are next in line for a ticket spinlock, or a vcpu that gets
scheduled but is not supposed to grab the lock yet can give
some CPU time to the vcpu that should get the lock next.

I believe the IBM PPC64 people have done some work to implement
just that.

-- 
All Rights Reversed
