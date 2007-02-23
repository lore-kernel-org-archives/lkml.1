Return-Path: <linux-kernel-owner+w=401wt.eu-S1750796AbXBWDTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750796AbXBWDTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 22:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbXBWDTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 22:19:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXBWDTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 22:19:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
X-Fcc: ~/Mail/utrace
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] UML utrace support, step 1
In-Reply-To: Jeff Dike's message of  Wednesday, 21 February 2007 13:18:11 -0500 <20070221181811.GA5845@ccure.user-mode-linux.org>
Emacs: the definitive fritterware.
Message-Id: <20070223031903.A55241800E4@magilla.sf.frob.com>
Date: Thu, 22 Feb 2007 19:19:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, I'll do it this way.

Your replacement patch still has utrace_regset stuff in it, so it doesn't
compile without the later patches in the series.  Try applying only
utrace-tracehook.patch from the series, then get it to build and make your
utrace-tracehook-um.patch.  Then apply only utrace-regset.patch on top of
that, and get that building to make utrace-regset-um.patch.  Then apply
utrace-core.patch and utrace-ptrace-compat.patch to get ptrace finally
working again and make utrace-ptrace-compat-um.patch.

> Yup, I'll leave this here, with .name initialized as SUBARCH, with the
> regsets defined in sys-$(ARCH) somewhere.

You'll still find this insufficient when you get to biarch support (x86_64).
At least you'll have to add another one elsewhere too, and make
utrace_native_view refer to both.

> Fixed.  block-step is hardware-trap-on-branch or something similar?

Correct.

> No, this is with preempt off.

Ok.  We do seem to have a problem when the host has CONFIG_PREEMPT=y, which
makes me suspect it might be a race problem that could also hit with enough
hardware parallelism.  If you get a chance to try that and can characterize
the way it misbehaves at the level of specific ptrace/wait calls, that
would be a great help.  Otherwise I'll try to look into it when I get some
time, but it's falling down the queue a bit since people don't seem too put
out about it right now.


Thanks very much,
Roland
