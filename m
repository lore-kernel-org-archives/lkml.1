Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYFEO4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYFEO4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYFEO4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:56:23 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64980 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753907AbYFEO4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:56:22 -0400
Date: Thu, 5 Jun 2008 15:55:41 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 8/8] x86: I/O APIC: Timer through 8259A second-chance
In-Reply-To: <20080605091949.GA2307@elte.hu>
Message-ID: <Pine.LNX.4.55.0806051541210.2875@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805271950010.18833@cliff.in.clinika.pl>
 <20080531101832.GA15170@elte.hu> <20080605091949.GA2307@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008, Ingo Molnar wrote:

> -tip testing found an IO-APIC related hang, and i bisected it down to 
> the problem below. What do you think about my solution? Another option 
> would be to add the lapic as a clockevent device in the failure path. 
> (since we know the NMI watchdog wont work)

 It seems wrong to me to set timer_through_8259 in apic_{32,64}.c -- can I
get .config for this setup as well as the bootstrap log?  Why is the 8259A
needed here to supply the timer interrupt?  It shouldn't be needed except
as arranged in check_timer() -- elsewhere the corresponding I/O APIC input
is not set up correctly.

 Note I have chosen the default value of timer_through_8259 deliberately
to trigger dodgy cases like this ;) so that they can be investigated.

  Maciej
