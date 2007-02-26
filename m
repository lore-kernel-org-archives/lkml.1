Return-Path: <linux-kernel-owner+w=401wt.eu-S932510AbXBZVRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbXBZVRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbXBZVRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:17:49 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34553 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510AbXBZVRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:17:48 -0500
Date: Mon, 26 Feb 2007 13:17:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Milton Miller <miltonm@bga.com>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: Make sure we populate the initroot filesystem late enough
In-Reply-To: <1172523468.3560.2.camel@shinybook.infradead.org>
Message-ID: <Pine.LNX.4.64.0702261315080.12485@woody.linux-foundation.org>
References: <1172462466.3971.46.camel@shinybook.infradead.org> 
 <35684e789e5c2447eab393c8946efcb9@bga.com> <1172523468.3560.2.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Feb 2007, David Woodhouse wrote:
> 
> Now I'm starting to wonder if it's something the firmware sets up to DMA
> to a certain region of memory, which makes it non-deterministic. And the
> other things we're blaming are only making a difference because they
> change the layout of what we have in memory.

USB controller issues? We used to have these really hard-to-debug problems 
with the USB controller being active and having had the BIOS set up the 
command queues etc. Really subtle. It's why we now have PCI quirks for 
shutting up (most) USB controllers very early.

If there is some USB controller that we miss, or that sets up its command 
chain to some unexpected area (so that USB is active and corrupting memory 
even very early on), that could explain it.

		Linus
