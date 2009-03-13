Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbZCMDFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbZCMDFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbZCMDFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:05:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:53295 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZCMDFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:05:21 -0400
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Timur Tabi <timur@freescale.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, jirislaby@gmail.com, will.newton@gmail.com,
       hancockrwd@gmail.com, jeremy@goop.org
In-Reply-To: <ed82fe3e0903121205k552a83bft9ac3b63c64a293c8@mail.gmail.com>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
	 <ed82fe3e0903110948w542a864dj821106900755f14e@mail.gmail.com>
	 <20090311165806.0b6838ab@lxorguk.ukuu.org.uk>
	 <49B80081.5060703@freescale.com> <1236808722.7086.66.camel@pasglop>
	 <fa686aa40903111945g53a0ba5au200fe9362e315175@mail.gmail.com>
	 <ed82fe3e0903120854r2d8f23d8r249a8e510a2fbc4c@mail.gmail.com>
	 <fa686aa40903120901me307a54y3511f4bafc6242e6@mail.gmail.com>
	 <49B9362D.3090805@freescale.com> <1236876609.5090.934.camel@laptop>
	 <ed82fe3e0903121205k552a83bft9ac3b63c64a293c8@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 14:03:41 +1100
Message-Id: <1236913421.25062.19.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But that's the thing - I don't want a required delay inside the loop.
> 
> I guess I'm going to have to think about this for a while.  I'd like
> to see something like cycles_per_usec() as a companion function to
> get_cycles().

I think that's where you're wrong :-)

Just require the delay inside the loop, it will make everything nicer.
There are also some good reasons to do that:

 - The delay between "polls" of the register may have to be controlled,
for example some HW will choke if polled too fast

 - If you aren't in an atomic section, you may want to use msleep() and
thus be schedule friendly

 - It fixes all the problems mentioned earlier

Cheers,
Ben.

