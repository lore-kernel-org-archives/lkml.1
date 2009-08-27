Return-Path: <linux-kernel-owner+w=401wt.eu-S1751324AbZH0KxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbZH0KxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 06:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZH0KxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 06:53:24 -0400
Received: from ozlabs.org ([203.10.76.45]:46910 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbZH0KxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 06:53:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.31-rc7-git2: Reported regressions 2.6.29 -> 2.6.30
Date: Thu, 27 Aug 2009 20:23:20 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Frans Pop <elendil@planet.nl>, zajec5@gmail.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, protasnb@gmail.com,
       linux-acpi@vger.kernel.org, kernel-testers@vger.kernel.org,
       torvalds@linux-foundation.org, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <lenb@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera> <200908261833.37310.elendil@planet.nl> <20090826123647.e60d9555.akpm@linux-foundation.org>
In-Reply-To: <20090826123647.e60d9555.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908272023.21288.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 05:06:47 am Andrew Morton wrote:
> So in my tree I reworked it so that the new `force' arg gets passed
> through appropriately.  It compiles cleanly but I'd suggest that Len
> simply drop "misc:work_on_cpu-acpi" and we send it back to Rusty for
> some rechecking (sorry).

Sure.  My main motivation is to get rid of cpumasks on the stack; while
there, I tried to fix this up properly.

> Rusty/Len: please work out why the title for that patch went silly.

git-quiltimport uses the patch names, and doesn't extract the title.  I
assume that's what Stephen uses.  I didn't rename the patch when I rewrote
it not to use work_on_cpu.

> Rusty, please self-administer smackings for
> 
> 		struct set_throttling_info sti
> 			= { pr, p_throttling, t_state.target_state };
> 
> these things always start out simple and end up not-simple, so some poor
> schmuck has to clean them up so stuff doesn't break.
> 
> 		struct set_throttling_info sti = {
> 			.pr = pr,
> 			.p_throttling = p_throttling,
> 			.target_state = t_state.target_state,
> 			.force = force
> 		};
> 
> is better!

Meh... same concept applies to function arguments, and we rely on typechecking
to catch that (though we have little choice in C).

> My linux-next repair job:

OK, I've dropped these from my tree entirely to avoid more problems.

Can you take them?  They're not really at home in my tree.

arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
misc:work_on_cpu-acpi.patch
misc:work_on_cpu-acpi-fix.patch
misc:work_on_cpu-dcdbas.patch

You can fetch them from http://ozlabs.org/~rusty/kernel/rr-latest/

(You'll want to rename the last three something sane...)

Thanks,
Rusty.
