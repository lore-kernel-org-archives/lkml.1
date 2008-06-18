Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYFRQT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYFRQT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbYFRQTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:19:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:10296 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYFRQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dTHVZWwU1T8lmKF/m1fcQjqCgsxyOo5h67Zyfky35tYp/shV0rmuoeLVBFWeYlemL/
         HLjMJDOs6RsI9zOf8WuMzN+iCJPvEGWyvX3R0/L6OREtsNzrLUqTI/RoFIKoC8+bXrTV
         PaHfwG04XzLKh8GVxSNR5KAWPl9PoDZryqxnw=
Message-ID: <19f34abd0806180919v5a8c21e7ua7e1f928d8a53ab4@mail.gmail.com>
Date: Wed, 18 Jun 2008 18:19:46 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: more header fixes
Cc: linux-kernel@vger.kernel.org, "the arch/x86 maintainers" <x86@kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080618103006.GF15255@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080610214544.GA14824@damson.getinternet.no>
	 <20080618103006.GF15255@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 12:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> PS: I now have a pretty cool framework in Perl for parsing and
>> checking headers. And it can be used to transform them automatically
>> too. So if you want to standardize the guard format of all the headers
>> in one go, we have the means to do it quickly and efficiently...
>
> very nice! I think the reference should be something like the unified
> include/asm-x86/processor.h.
>
> could you try a run with that and put the result into a git tree for me
> to pull for review? I think we want to finetune that result and do a
> flag day for those cleanups, right after all the x86 topics went into
> v2.6.27.

Done! You can pull the 'for-x86' branch of

    git pull git://git.kernel.org/pub/scm/linux/kernel/git/vegard/linux-2.6-headers.git
for-x86

(that's gonna wrap.) The first commit
(d160e5c4f1b912ec7c1583c393bb3db66cdb63c2) is the interesting one, the
rest are just manual fix-ups.

I've looked over most of it to make sure everything's okay; in
addition, the diff consists of change in preprocessor lines only.
'make headers_check' also succeeds, although no change here should
change the result of that.


The headers that still need to be looked at manually (probably because
there was no guard there in the first place), are:

# add include/asm-x86/mach-visws/entry_arch.h
# add include/asm-x86/mach-visws/setup_arch.h
# add include/asm-x86/mach-visws/smpboot_hooks.h
# add include/asm-x86/posix_types.h
# add include/asm-x86/mach-default/pci-functions.h
# add include/asm-x86/mach-default/entry_arch.h
# add include/asm-x86/mach-default/do_timer.h
# add include/asm-x86/mach-default/smpboot_hooks.h
# add include/asm-x86/vic.h
# add include/asm-x86/suspend_32.h
# add include/asm-x86/calling.h
# add include/asm-x86/alternative-asm.h
# add include/asm-x86/processor-cyrix.h
# add include/asm-x86/mach-voyager/entry_arch.h
# add include/asm-x86/mach-voyager/do_timer.h
# add include/asm-x86/mach-voyager/setup_arch.h
# add include/asm-x86/mach-rdc321x/rdc321x_defs.h
# add include/asm-x86/unistd.h
# add include/asm-x86/irqflags.h
# add include/asm-x86/vmi.h
# add include/asm-x86/voyager.h
# add include/asm-x86/frame.h


Vegard (a.k.a. "The Churninator")

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
