Return-Path: <linux-kernel-owner+w=401wt.eu-S1762630AbYAHRB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762630AbYAHRB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbYAHRBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:01:50 -0500
Received: from mail.suse.de ([195.135.220.2]:60091 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbYAHRBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:01:49 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch 2/2] Use the stack frames to get exact stack-traces for CONFIG_FRAMEPOINTER on x86-64
From: Andi Kleen <andi@firstfloor.org>
References: <20080107211437.5ba42f18@laptopd505.fenrus.org>
Date: Tue, 08 Jan 2008 18:01:48 +0100
In-Reply-To: <20080107211437.5ba42f18@laptopd505.fenrus.org> (Arjan van de Ven's message of "Mon\, 7 Jan 2008 21\:14\:37 -0800")
Message-ID: <p73fxx8qmir.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> Subject: Use the stack frames to get exact stack-traces for CONFIG_FRAMEPOINTER on x86-64
> From: Arjan van de Ven <arjan@linux.intel.com>
>
> x86 32 bit already has this feature: This patch uses the stack frames with

You would also need to add frame pointers to all .S functions, otherwise
it will stop there.

> frame pointer into an exact stack trace, by following the frame pointer.
> This only affects kernels built with the CONFIG_FRAME_POINTER config option
> enabled, and greatly reduces the amount of noise in oopses.

Well it's still the wrong way to do this. The correct way is to reintegrate
Jan's dwarf2 unwinder. Incidentially that code supports frame pointer
unwinding too, but of course with the same limits as described above.

> The code tries to use the frame pointers to do a backtrace, but if it smells
> iffy or invalid, falls back to the traditional way of printing backtraces,
> to make sure that at least some useful backtrace is created.

That will likely happen in most non trivial cases (interrupts/exceptions etc.)

-Andi
