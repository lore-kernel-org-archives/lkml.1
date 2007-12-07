Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbXLGKpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbXLGKpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 05:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbXLGKo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 05:44:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbXLGKo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 05:44:59 -0500
To: "David P. Reed" <dpreed@reed.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
From: Andi Kleen <andi@firstfloor.org>
References: <475879CD.9080006@reed.com>
Date: Fri, 07 Dec 2007 11:44:57 +0100
In-Reply-To: <475879CD.9080006@reed.com> (David P. Reed's message of "Thu\, 06 Dec 2007 17\:38\:05 -0500")
Message-ID: <p733auekcly.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"David P. Reed" <dpreed@reed.com> writes:
>
> ANy help/suggestions?

Use a variable for the port and and do a early quirk to change 
the port to something safe on your chipset? 

Ok there might be code using outb_p() before the early quirks,
but should be possible to find using instrumentation.

Also the port assignment might not be chipset specific, but BIOS
specific, then you would need to match the DMI identifier. The 
disadvantage of that is that there are usually other BIOS
with other identifiers but the same problem around.

> Changing the delay instruction sequence from the outb to short jumps
> might be the safe thing.  But Linus, et al. may have experience with
> that on other architectures like older Pentiums etc.

I don't think that makes sense to do on anything modern. The trouble
is that the jumps will effectively execute near "infinitely fast" on any
modern CPU compared to the bus. But the delay really needs to be something
that is about IO port speed. Ok in theory you could try to measure
a outb using RDTSC and then use udelay, but first you would need
a safe port for that already and then RDTSC is not necessarily constant.

-Andi
