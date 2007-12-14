Return-Path: <linux-kernel-owner+w=401wt.eu-S1765119AbXLNJwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765119AbXLNJwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXLNJwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:52:05 -0500
Received: from [194.117.236.238] ([194.117.236.238]:54596 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759714AbXLNJwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:52:02 -0500
Date: Fri, 14 Dec 2007 14:48:41 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Johannes Weiner <hannes-kernel@saeurebad.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071214144841.2e4e4992@linux360.ro>
In-Reply-To: <x77ijiryl1.fsf@saeurebad.de>
References: <20071214004710.03f37774@linux360.ro>
	<x77ijiryl1.fsf@saeurebad.de>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 23:58:50 +0100
Johannes Weiner <hannes-kernel@saeurebad.de> wrote:
> I would find this way more readable:
> 
> 	if (lo & ENABLE_C1E_MASK) {
> #ifdef CONFIG_X86_AMD_C1E_WORKAROUND
> 		if (disable_amd_c1e) {
> 			...
> #else
> 		return 1;
> #endif
> 	}

I wanted to avoid using too many tabs, as that would require the lines
inside the if block to be split too many times. I'll resubmit the patch
if you think it's necessary.

> Why does it require to be enabled by compile-time AND run-time?  Is
> that something you might want to decide on every boot?  Could we make
> it settable at boot-time xor at compile-time?

Making it settable only at boot-time means compiling in unnecessary
code. Also, making it settable only at compile-time would be bad for
distros that distribute binary kernels, as some users may experience
worse power savings with dynticks than with C1E (especially when C2, C3
and higher C-states are not available, due to brain-dead firmware).
This allows them to opt for leaving C1E enabled.

It is not required to enable it at both compile-time and boot-time. You
enable it at compile-time and then you _can disable_ it at boot-time.
