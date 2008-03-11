Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbYCKKns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbYCKKns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbYCKKni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:43:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58412 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYCKKni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:43:38 -0400
Date: Tue, 11 Mar 2008 11:45:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH REPOST for 2.6.25] Use an own random generator for pageattr-test.c
Message-ID: <20080311104531.GB18917@one.firstfloor.org>
References: <20080311013014.GA28682@basil.nowhere.org> <alpine.LFD.1.00.0803110922430.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803110922430.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 09:25:21AM +0100, Thomas Gleixner wrote:
> On Tue, 11 Mar 2008, Andi Kleen wrote:
> > Use an own random generator for pageattr-test.c
> > 
> > [Repost. Please ack/nack. This is a bug fix and imho a .25 late merge 
> > candidate because it fixes a subtle bug]
> 
> Care to point out which "subtle bug" is fixed ? 
> 
> You replace a random generator by another to get repeateable
> sequences. The non repeatability of the cpa test patterns is hardly a
> "subtle bug".

The subtle bug(s) are first that it is not repeatable (it really should),
then that it only initializes the CPU where the code first runs
(since srandom32 is per CPU) and later might change CPUs and then that it 
adds totally unnecessary state bits to CPU #0 (or whatever runs first).

-Andii

