Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbYFITv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbYFITv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYFITvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:51:18 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64379 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752747AbYFITvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:51:17 -0400
Date: Mon, 9 Jun 2008 20:49:46 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: update mptable v7 - fix
In-Reply-To: <20080609190911.GA20997@elte.hu>
Message-ID: <Pine.LNX.4.55.0806092046090.26593@cliff.in.clinika.pl>
References: <200805041823.57198.yhlu.kernel@gmail.com>
 <200805251600.26325.yhlu.kernel@gmail.com> <200806011317.38622.yhlu.kernel@gmail.com>
 <200806081953.26877.yhlu.kernel@gmail.com> <20080609101318.GA23873@elte.hu>
 <86802c440806091051j30ac4480oe6be0a7b288f772c@mail.gmail.com>
 <20080609190911.GA20997@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Ingo Molnar wrote:

> here's the condition:
> 
> config X86_MPPARSE
>         def_bool y
>         depends on (X86_32 && (X86_LOCAL_APIC && !X86_VISWS)) || X86_64
> 
> 64-bit has it unconditionally, 32-bit has it on SMP, UP-IOAPIC or 
> UP-local-APIC mode. [ (and VISWS is an ugly complication we should try 
> to eradicate similarly to NUMAQ, if possible :-) ]

 Given X86_64 selects X86_LOCAL_APIC I am not sure the redundancy seen
above does not actually obscure the logic behind...  I think:

	depends on X86_LOCAL_APIC && !X86_VISWS

would be clearer and get the same.

  Maciej
