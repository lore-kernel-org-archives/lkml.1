Return-Path: <linux-kernel-owner+w=401wt.eu-S932716AbXBWP6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbXBWP6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 10:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932719AbXBWP6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 10:58:51 -0500
Received: from [198.99.130.12] ([198.99.130.12]:38600 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932716AbXBWP6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 10:58:50 -0500
Date: Fri, 23 Feb 2007 10:50:31 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] UML utrace support, step 1
Message-ID: <20070223155031.GD5198@ccure.user-mode-linux.org>
References: <20070221181811.GA5845@ccure.user-mode-linux.org> <20070223031903.A55241800E4@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223031903.A55241800E4@magilla.sf.frob.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 07:19:03PM -0800, Roland McGrath wrote:
> Your replacement patch still has utrace_regset stuff in it, so it doesn't
> compile without the later patches in the series.  Try applying only
> utrace-tracehook.patch from the series, then get it to build and make your
> utrace-tracehook-um.patch.  Then apply only utrace-regset.patch on top of
> that, and get that building to make utrace-regset-um.patch.  Then apply
> utrace-core.patch and utrace-ptrace-compat.patch to get ptrace finally
> working again and make utrace-ptrace-compat-um.patch.

Ah, I was building with all of utrace, and observing that it didn't compile
without all the bits in that patch.  I'll back out the bits of utrace
I don't need yet and send another patch.

> You'll still find this insufficient when you get to biarch support (x86_64).
> At least you'll have to add another one elsewhere too, and make
> utrace_native_view refer to both.

OK, I'll deal with that when I get to it.

> Ok.  We do seem to have a problem when the host has CONFIG_PREEMPT=y, which
> makes me suspect it might be a race problem that could also hit with enough
> hardware parallelism.  If you get a chance to try that and can characterize
> the way it misbehaves at the level of specific ptrace/wait calls, that
> would be a great help.  Otherwise I'll try to look into it when I get some
> time, but it's falling down the queue a bit since people don't seem too put
> out about it right now.

I'll turn on preempt and see what happens.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
