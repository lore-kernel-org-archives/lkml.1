Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZFCGdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZFCGdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZFCGd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:33:28 -0400
Received: from claw.goop.org ([74.207.240.146]:50656 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZFCGd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:33:27 -0400
Message-ID: <4A261932.2020200@goop.org>
Date: Wed, 03 Jun 2009 16:33:22 +1000
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 	kernels
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu>	 <4A1C3805.7060404@goop.org> <20090528061702.GB6920@wotan.suse.de>	 <20090530102330.GC16913@elte.hu> <20090602141802.GC3914@think> <a36005b50906020749p22b89693k5c4ae171d18966a7@mail.gmail.com>
In-Reply-To: <a36005b50906020749p22b89693k5c4ae171d18966a7@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> Ingo pointed to a way which doesn't negatively impact the
> performance of the Xen kernel and reduces the overhead (dynamic
> patching)

The pvops code is already fully dynamically patched, which replaces all 
the indirect calls with either direct calls, inline instructions or 
nops.  It has been this way from the initial implementation.

More recently I changed the calling convention on some of the most 
common critical-path ops to reduce the register pressure caused by the 
function call clobbers; you just don't need a pile of registers to 
disable interrupts.

Ingo knows all this, so I'm not sure what further patching he's 
suggesting.  I don't see any more likely candidates, but I'm open to 
suggestions.

    J
