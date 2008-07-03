Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbYGCHHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbYGCHHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYGCG5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbYGCDBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 23:01:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: TAKADA Yoshihito <takada@mbf.nifty.com>
X-Fcc: ~/Mail/linus
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] x86 ptrace: fix PTRACE_GETFPXREGS error
In-Reply-To: TAKADA Yoshihito's message of  Thursday, 3 July 2008 10:58:58 +0900 <20080703.105858.193690507.takada@mbf.nifty.com>
References: <20080630.134445.193700135.takada@mbf.nifty.com>
	<20080630210241.93738154077@magilla.localdomain>
	<20080703.105858.193690507.takada@mbf.nifty.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080703030001.4CC2215416D@magilla.localdomain>
Date: Wed,  2 Jul 2008 20:00:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi. Thanks for your right patch.
> BTW, are FXSAVE and FXRSTOR instructions device?
> Is it right to return ENODEV?
> I think I had bettor return EXIO or ENOTSUP. 
> If it discussed, tell me URL of tree at lkml.org.

I don't think it was discussed.  It's clearly documented in the
linux/regset.h kerneldoc comments that define the interface.  
I don't recall any feedback about error codes when that went in.

Device, eh, whatever.  We're not going to add a new code that means
precisely "this user_regset refers to hardware not present", that would be
silly.  It's going to be chosen by some analogy with the original use of
some existing code.  ENXIO is fine too.  I probably chose ENODEV over ENXIO
just because it's easier to read the name and remember what it might mean
(and it's easier to type).  

All that really matters is that for the particular case of user_regset
functions, there be clearly specified one errno code that means "all's well,
but this supported hardware is not here".  Then callers know to check for
that, and any other error code value is potentially an unexpected sort of
error.  I see nothing wrong with ENODEV.  The only thing wrong with ENXIO is
trying to type it correctly twice in a row.  ENOTSUP does not seem like a
good fit as an analogy to its other specified uses.


Thanks,
Roland
