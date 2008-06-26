Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbYFZSAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbYFZSAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYFZSAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:00:22 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39492 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYFZSAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:00:21 -0400
Date: Thu, 26 Jun 2008 19:30:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: more header fixes
Message-ID: <20080626173012.GA13139@uranus.ravnborg.org>
References: <20080610214544.GA14824@damson.getinternet.no> <20080618103006.GF15255@elte.hu> <19f34abd0806180919v5a8c21e7ua7e1f928d8a53ab4@mail.gmail.com> <20080626120202.GH29619@elte.hu> <20080626133047.GA11762@uranus.ravnborg.org> <19f34abd0806260644s30698d34jd227c170aae8278c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806260644s30698d34jd227c170aae8278c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 03:44:51PM +0200, Vegard Nossum wrote:
> On Thu, Jun 26, 2008 at 3:30 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > Can I ask you to chase all uses of #include <asm-x86/xxx.h>
> > and convert them to #include <asm/xxx.h>
> >
> > When we move include/asm-x86 to arch/x86/include/asm this is needed and
> > better to fix these sooner.
> 
> Hm. I can't really seem to find many:
> 
> ./Documentation/lguest/lguest.c:#include "asm-x86/bootparam.h"
> ./arch/um/sys-x86_64/syscall_table.c:#include <asm-x86/unistd_64.h>
> ./arch/um/sys-x86_64/syscall_table.c:#include <asm-x86/unistd_64.h>
> ./arch/ia64/ia32/audit.c:#include <asm-x86/unistd_32.h>
> 
> ..and I don't even know how to fix them. It seems that we might want
> to use filesystem links here instead? (Git should be able to handle
> that.)

Looking at the list again you are right that this is not the type of
'bugs' that I initially thought it was.
We should leave them as is for now and fix it up when
we decide to move the headers.


> E.g. so that arch/ia64/include/asm/unistd_32.h ->
> arch/x86/include/asm/unistd_32.h. Then arch/ia64/ia32/audit.c can
> #include <asm/unistd_32.h>.
It is better to be explicit in the include than trying to do clever
tricks behind the bag og gcc.

	Sam
