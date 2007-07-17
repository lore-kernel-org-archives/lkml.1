Return-Path: <linux-kernel-owner+w=401wt.eu-S935588AbXGQTgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935588AbXGQTgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXGQTgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:36:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34322
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbXGQTgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:36:03 -0400
Date: Tue, 17 Jul 2007 12:36:00 -0700 (PDT)
Message-Id: <20070717.123600.71091634.davem@davemloft.net>
To: oleg@tv-sign.ru
Cc: torvalds@linux-foundation.org, 76306.1226@compuserve.com, mingo@elte.hu,
       roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Q: a bogus set_fs(USER_DS) in setup_frame/setup_rt_frame ?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070717171535.GA431@tv-sign.ru>
References: <20070717154638.GA342@tv-sign.ru>
	<alpine.LFD.0.999.0707170902570.19166@woody.linux-foundation.org>
	<20070717171535.GA431@tv-sign.ru>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@tv-sign.ru>
Date: Tue, 17 Jul 2007 21:15:35 +0400

> Also, sparc does something strange with do_sigaltstack(). It first copies
> stack_t to the local variable, then sets KERNEL_DS to access it from
> do_sigaltstack().
> 
> IOW, what's wrong with the patch below? Why should we ignore errors other
> than -EFAULT?

Nothing wrong with it.

The code is this way because it was simply copied over from
the signal32.c implementation which has to translate around
the 32-bit types into the 64-bit ones the kernel wants.

But since the 64-bit side doesn't need the translations,
it doesn't need to do the funny do_sigaltstack() call sequence
either.

I'll apply your patch, thanks!
