Return-Path: <linux-kernel-owner+w=401wt.eu-S1763169AbXHXQvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763169AbXHXQvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbXHXQvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:51:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34339 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbXHXQvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:51:04 -0400
In-Reply-To: <20070824085203.42f4305c@freepuppy.rosehill.hemminger.net>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: akepner@sgi.com, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, netdev-owner@vger.kernel.org,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>
MIME-Version: 1.0
Subject: Re: RFC: issues concerning the next NAPI interface
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF0002C3DB.2E4C4A38-ON88257341.005B1253-88257341.005C7C2A@us.ibm.com>
From: David Stevens <dlstevens@us.ibm.com>
Date: Fri, 24 Aug 2007 09:50:58 -0700
X-MIMETrack: Serialize by Router on D03NM121/03/M/IBM(Release 7.0.2FP2HF51 | June 19, 2007) at
 08/24/2007 10:51:00,
	Serialize complete at 08/24/2007 10:51:00
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@linux-foundation.org> wrote on 08/24/2007 
08:52:03 AM:

> 
> You need hardware support for deferred interrupts. Most devices have it 
> (e1000, sky2, tg3)
> and it interacts well with NAPI. It is not a generic thing you want done 
by the stack,
> you want the hardware to hold off interrupts until X packets or Y usecs 
have expired.

        For generic hardware that doesn't support it, couldn't you use an 
estimater
and adjust the timer dynamicly in software based on sampled values? Switch 
to per-packet
interrupts when the receive rate is low...
        Actually, that's how I thought NAPI worked before I found out 
otherwise (ie,
before I looked :-)).

        The hardware-accelerated one is essentially siloing as done by 
ancient serial
devices on UNIX systems. If you had a tunable for a target count, and an 
estimator
for the time interval, then switch to per-packet when the estimator 
exceeds a tunable
max threshold (and also, I suppose, if you near overflowing the ring on 
the min
timer granularity), you get almost all of it, right?
        Problem is if it increases rapidly, you may drop packets before 
you notice
that the ring is full in the current estimated interval.

 +-DLS


