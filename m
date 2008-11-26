Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbYKZQex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbYKZQex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYKZQep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:34:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54968 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYKZQeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:34:44 -0500
Date: Wed, 26 Nov 2008 17:45:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       andi@firstfloor.org, sfr@canb.auug.org.au
Subject: Re: [patch 21/24] perfmon: Intel architectural PMU support (x86)
Message-ID: <20081126164511.GA6703@one.firstfloor.org>
References: <492d0c0e.06e2660a.1583.ffffcc0a@mx.google.com> <alpine.LFD.2.00.0811261446070.3325@localhost.localdomain> <7c86c4470811260745s293ae0bbw1cf53642d4f88416@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811260745s293ae0bbw1cf53642d4f88416@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Both perfmon_intel_arch.c and perfmon_amd64.c are supposed to be kernel modules.
> They are hardcoded right now to make the patch simpler. Have PMU description be
> modules is a key features because it allows adding new processor support without
> necessarily patch the core kernel or rebooting. This has been working

To install the new processor in the first place you have 
to reboot anyways.

Also typically at least for new families (which tend to be the
only ones with radically new performance counters) it's typically
needed to change some things in the core kernel anyways. So 
this doesn't seem like a really useful feature.

> nicely on Itanium.
> With the introduction of Intel architectural Perfmon (IA32 SDM chapter
> 18), this becomes
> possible on Intel X86 as well.

It becomes possible, but without having to use any modules. It should
just work.

Probably even without it worked -- at least if you limit yourself to 
family 6 -- because the register layout all stayed the same too.

That said having modular PMUs is probably a good thing for
distribution kernels, but there is really no need for any 
code compromises just to avoid a core kernel patch now and then.

-Andi
