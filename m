Return-Path: <linux-kernel-owner+w=401wt.eu-S1751457Ab0APUxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab0APUxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 15:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077Ab0APUxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 15:53:46 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:61219 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab0APUxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 15:53:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ox3nB/SrwksPiiC3Fb5OJWfedHDjPBZpxjq1yGpDPZ/kW5aLNnTZx9cg15JOqAXgYC
         1fa1WnHvSJ2II0vv92IYWNe94kKxnuKSWF01fkvT94mYJc8v6hseWFcWeP+d1l/3FLlj
         GT1r/NmYpLhbM3OkonyArQKcRbrokIGGcWdw8=
Date: Sat, 16 Jan 2010 23:53:42 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20100116205342.GA5725@lenovo>
References: <20100116170338.GA17175@elte.hu> <alpine.LFD.2.00.1001161233300.13231@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001161233300.13231@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 12:34:42PM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 16 Jan 2010, Ingo Molnar wrote:
> > 
> > Cyrill Gorcunov (1):
> >       x86: kernel_thread() -- initialize SS to a known state
> 
> This looks bogus. Why does it do it only on x86-64?
> 
> Either people care about SS or they don't (the answer, I suspect, is "they 
> don't"). But if they care, we should do it on both 32-bit _and_ 64-bit, 
> no?
> 
> 		Linus

Linus, this is Xen specific. There was a Xen related series sent by Ian,
and seems we still need this patch together with get_kernel_rpl() (as I understand,
I'm not familiar with Xen code, that was a suspicious about SS as it's said
in commit message). So Ian mentioned

|
| > Yeah, I didn't found any explicit %ss reloading for this _particular_
| > case (as I marked in patch changelog). So the only suspicious is Xen
| > itself. So as only Christian get ability to test -- we will see the
| > results.
|
| The difference with Xen is that it must squash the RPL of SS (to 3 for
| 64 bit and 1 for 32 bit, 32 bit doesn't matter here though). Perhaps a
| NULL selector can only have RPL==0? (I'm away from my architecture docs
| so I can't check). In any case specifying a non-NULL SS selector allows
| the squashing to occur correctly.
|

In turn reported said that only _this_ patch alone doesn't help him and
Ian replied we need both patches.

Ian CC'ed if details needed.

	-- Cyrill
