Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYGMC6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYGMC6t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 22:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYGMC6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 22:58:41 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63160 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752279AbYGMC6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 22:58:40 -0400
Date: Sun, 13 Jul 2008 03:58:12 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Recover timer_ack lost in the merge of the NMI
 watchdog
In-Reply-To: <20080711185511.GB17203@elte.hu>
Message-ID: <Pine.LNX.4.55.0807130339010.6739@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807111936480.31940@cliff.in.clinika.pl>
 <20080711185511.GB17203@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008, Ingo Molnar wrote:

> i've applied your fixes to tip/x86/core:
> 
>  Maciej W. Rozycki (4):
>       x86: L-APIC: Set IRQ0 as edge-triggered
>       x86: L-APIC: Always fully configure IRQ0
>       x86: I/O APIC: Never configure IRQ2
>       x86: Recover timer_ack lost in the merge of the NMI watchdog

 Thanks, please apply "x86: I/O APIC: Remove an IRQ2-mask hack" on top of
these.  Then what currently comprises dmi_ignore_irq0_timer_override() can
be done more properly as soon as we know how to get information about
INTIN0/2 configurations from the SB400.  Furthermore, following
considerations in the other mail, I think the HPET driver should use the
notion of ISA IRQ numbers by mapping them appropriately from I/O APIC pin
numbers.  Reusing pin_2_irq() for this purpose seems a reasonable way of
doing this to me.

  Maciej
