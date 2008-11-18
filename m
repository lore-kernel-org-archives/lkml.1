Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYKRWyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYKRWyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYKRWyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:54:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYKRWyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:54:05 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Jan Beulich <jbeulich@novell.com>, heukelum@fastmail.fm,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Glauber Costa <gcosta@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC,v2] x86_64: save_args out of line
In-Reply-To: Ingo Molnar's message of  Tuesday, 18 November 2008 16:00:24 +0100 <20081118150024.GD30358@elte.hu>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm>
	<20081117175232.GA13766@mailshack.com>
	<49228648.76E4.0078.0@novell.com>
	<20081118111633.GA21036@mailshack.com>
	<4922C863.76E4.0078.0@novell.com>
	<20081118140349.GC23479@elte.hu>
	<4922E4D4.76E4.0078.0@novell.com>
	<20081118150024.GD30358@elte.hu>
X-Shopping-List: (1) Cinematic atypical money
   (2) Ominous winters
   (3) Paradoxical organs
   (4) Symbolical hamster-lip pronunciations
Message-Id: <20081118225336.60FFA1544EB@magilla.localdomain>
Date: Tue, 18 Nov 2008 14:53:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> but that's the exception. Most of the annotations could be
> auto-generated.

Not really.  An implicit .cfi_undefined can be auto-generated for an
unannotated instruction with an output register.  An implicit .cfi_register
can be auto-generated for an unannotated register-to-register move.  An
implicit .cfi_same_value can be auto-generated when you can tell a register
is being written with the register or stack slot tha the current CFI state
says holds the caller's value of that register.  Beyond that, it gets into
either assumptions or hairy analysis of how stack slots are being used and
so forth.  

I don't think auto-generation is very a useful angle to take for this any
time soon.  Explicit (but simple) macros in the assembly is what I favor.


Thanks,
Roland
