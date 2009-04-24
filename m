Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbZDXPbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbZDXPbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 11:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZDXPbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 11:31:34 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34947 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbZDXPbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 11:31:34 -0400
Date: Fri, 24 Apr 2009 16:30:18 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 microcode: work_on_cpu and cleanup of the 
 synchronization logic
In-Reply-To: <b647ffbd0904240711v6e6930f5ia438bdcd69a015a4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904241612180.1612@blonde.anvils>
References: <1240258569.6195.8.camel@earth> <1240344440.5861.10.camel@earth>
  <1240439073.12721.23.camel@earth> <20090423082704.GD599@elte.hu> 
 <b647ffbd0904230155t61578496pf75fb79e54def3a3@mail.gmail.com> 
 <Pine.LNX.4.64.0904231807370.7545@blonde.anvils> 
 <b647ffbd0904231516x576c7ae4y36fedc9bc4fcf0f@mail.gmail.com> 
 <Pine.LNX.4.64.0904241300340.21735@blonde.anvils>
 <b647ffbd0904240711v6e6930f5ia438bdcd69a015a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, Dmitry Adamushko wrote:
> 
> Assumption: most of the CPUs (maybe with an exception of the boot-cpu
> when its ucode is updated by BIOS) upgrade from revisions A to B,
> where A and B are the same for all of them (well, at least B -- the
> most recent one [*]).
> 
> Then why bother loading/traversing firmware (or traversing .dat files)
> for each of them?
> 
> [*] btw., are all CPUs on SMP systems similar wrt model, stepping?

I'm not an authority on these matters, but I think it's true to say:
that's almost always the case in practice, and some vendors refuse to
support combinations of non-identical CPUs; but it's not necessarily
the case.  I think there was a product from one vendor (SGI??) which
most commonly had a mixture.

> 
> Even if not, we could do some caching so that if cpu-2 asks for
> intel-ucode/06-0f-0a and we know that cpu-1 has just done the same and
> still has a proper ucode in its buffer, then we just make a copy.

Okay, but don't spend too much code and ingenuity upon it.  And note
that when Intel get around to it (and the distros have caught up),
they will be moving away from the all-in-one /etc/microcode.dat
MICROCODE_OLD_INTERFACE, to the /lib/firmware/intel-ucode/06-0f-0a
style - so I don't think optimizing .dat read time is worth much.

Indeed, MICROCODE_OLD_INTERFACE is driven by /sbin/microcode_ctl
anyway, I don't think you should be second-guessing what it might
feed you.

Hugh
