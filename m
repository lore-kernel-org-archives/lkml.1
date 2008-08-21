Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbYHULwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbYHULwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759918AbYHULvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:51:48 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61264 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759889AbYHULvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:51:46 -0400
Date: Thu, 21 Aug 2008 12:51:14 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
In-Reply-To: <19f34abd0808210418w39341d05p43712356b352cdc9@mail.gmail.com>
Message-ID: <Pine.LNX.4.55.0808211240090.22938@cliff.in.clinika.pl>
References: <200808202106.41058.elendil@planet.nl>  <200808202138.13302.rjw@sisk.pl>
  <200808202226.45655.elendil@planet.nl>  <200808202356.33036.rjw@sisk.pl> 
 <Pine.LNX.4.55.0808211023020.22938@cliff.in.clinika.pl>
 <19f34abd0808210418w39341d05p43712356b352cdc9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008, Vegard Nossum wrote:

> I've also seen this a lot, so I have now written (I think) such a
> debug patch (it's very crude) and tested it on my laptop, which
> exhibits this problem.
[...]
> APIC error on CPU0: 00(40)
> Last 16 APIC writes:
[...]
> The order is from oldest (0) to newest (15) write. I don't see any
> writes to ICR in there, which means that IPIs can be ruled out? It
> seems that it is the write to Timer that causes it. In another place,
> we have this:

 You are correct about the ICR -- IPIs are unlikely to be a problem 
because only a couple of predefined vectors are used.  Besides, they are 
normally critical enoug for the system to become unstable if unhandled.

 Otherwise there is no correlation between the sequence of APIC writes and
an error triggering -- a bad vector in a LVT or interrupt redirection
entry will be reported whenever its associated interrupt line gets active
even though the entry might have been initialised long ago.  Depending on
the device signalling hardware interrupts may quite often be ignored for a
long time without affecting the stability of the rest of the system.

  Maciej
