Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbZAFKJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbZAFKJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZAFKJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:09:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44387 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbZAFKJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:09:20 -0500
Date: Tue, 6 Jan 2009 11:09:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC -tip 0/4] x86: reduce fixup of uaccess
Message-ID: <20090106100906.GA14185@elte.hu>
References: <4962CAAE.6090300@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4962CAAE.6090300@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> This is my second try to reduce fixup code size for exceptions of uaccess.
> 
> This patch series reduces fixup code for exceptions of uaccess in signal.
> 
> I gave up to make direct jump to end of function when an exception occurs.
> However, I thought fixup code could be reduced. The concept is that to add
> uaccess_err in thread_info and set it to -EFAULT on exception, finally check
> this value on the last of function.
> 
> Is this good to reduce code size?
> 
> The code size reductions are below;
> $ size *signal*.o.*
>    text	   data	    bss	    dec	    hex	filename
>    4741	      0	      0	   4741	   1285	ia32_signal.o.new
>    6006	      0	      0	   6006	   1776	ia32_signal.o.old
>    3577	      0	      0	   3577	    df9	signal.o.new
>    4540	      0	      0	   4540	   11bc	signal.o.old
>    3855	      0	      0	   3855	    f0f	signal32.o.new
>    4876	      0	      0	   4876	   130c	signal32.o.old

looks very nice! Since kernel execution is i-cache-cold in the typical 
case, this will probably transform into a performance improvement as well.

	Ingo
