Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbYILWdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbYILWdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYILWdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:33:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41344 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508AbYILWdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:33:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: linux-arch@vger.kernel.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HAVE_ARCH_TRACEHOOK and you
In-Reply-To: Russell King's message of  Friday, 12 September 2008 14:13:51 +0100 <20080912131351.GA31545@flint.arm.linux.org.uk>
References: <20080912025733.E55F415420D@magilla.localdomain>
	<20080912131351.GA31545@flint.arm.linux.org.uk>
X-Shopping-List: (1) Commodious inversion bag lunches
   (2) Malcontent lions
   (3) Horrendous injured pistons
Message-Id: <20080912223156.51D4815420D@magilla.localdomain>
Date: Fri, 12 Sep 2008 15:31:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> clean.  The only thing I did do was invent some alternative simpler
> helper functions rather than using the user_regset_copy* functions (to
> avoid taking the address of function arguments, which needlessly forces
> them onto the stack.)

Ideally those would get inlined so that doesn't happen.  Their only purpose
is to make it easier to write get/set functions in arch code.  Whatever you
find preferable in your arch code is certainly fine with me.  If you have
something different, or changes to those regset.h functions, that would be
of use for other arch code too, then bring them on (under a new subject
line if you don't mind).

> means sparc ends up allocating 38 * sizeof(u32) * sizeof(u32), and
> sparc64 ends up with 36 * sizeof(u64) * sizeof(u64), which must surely
> be wrong?

Yup!  Sure looks like Dave skipped the step where it says "test that core
dumps work ... and produce correct results". :-)


Thanks,
Roland
