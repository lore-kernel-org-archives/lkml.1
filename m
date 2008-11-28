Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYK1Sp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYK1Sp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 13:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYK1SpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 13:45:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36050 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYK1SpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 13:45:11 -0500
Date: Fri, 28 Nov 2008 19:55:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm
Subject: Re: [PATCH 2/5] x86: ret_from_fork - get rid of jump back
Message-ID: <20081128185546.GS6703@one.firstfloor.org>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com> <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com> <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com> <874p1u45ke.fsf@basil.nowhere.org> <20081126201054.GB2624@localhost> <20081127134121.GA22736@elte.hu> <20081127141637.GQ6703@one.firstfloor.org> <20081128134754.GA30140@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128134754.GA30140@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 02:47:54PM +0100, Ingo Molnar wrote:

Hi Ingo,

> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > But it gets worse than that: checking for _TIF_SYSCALL_TRACE is 
> > > completely unnecessary here because we clear that flag for every 
> > 
> > That's true. I found your 2005 changeset which did that, [...]
> 
> that's irrelevant, because all the necessary TIF_ flag processing is 
> already done in ret_from_sys_call.

Yes, that's true (as I wrote in my email), but it's just not dead because 
the audit code will take it (or used to handle both audit and fork before 
2005), just unnecessary because the later code checks it as well@). Ok it's
only a very subtle difference given.

It would have been nice if you had pruned at least the fork case
when you changed fork.c to always clear it, but that can be also
done now.

> 
> The unnecessary TIF_SYSCALL_TRACE code in the 64-bit ret_from_fork was 
> apparently added by you in 2002:

Yes, to be honest I don't remember why I did it this way. Most likely
the additional check was needed in some earlier iteration and then not pruned 
away when it became unnecessary. I remember I had some ordering problems
with strace very early on it might have been related to that. Or perhaps 
I just goofed up. In the current form it's certainly not great code.

Anyways I have no objections to removing it now, just one has to be
careful that the changed processing order (signals vs trace) -- which
is likely user visible -- won't break anything.

-Andi
