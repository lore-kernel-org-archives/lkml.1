Return-Path: <linux-kernel-owner+w=401wt.eu-S933826AbYCEMfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbYCEMfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbYCEMff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:35:35 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:49441 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238AbYCEMfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:35:33 -0500
Date: Wed, 5 Mar 2008 13:35:29 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christopher Li <sparse@chrisli.org>, yi.zhu@intel.com,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-sparse@vger.kernel.org,
       Josh Triplett <josh@freedesktop.org>
Subject: Re: [PATCH 6/9] drivers/net/wireless/iwlwifi/iwl-4965.c: Correct
 use of ! and &
In-Reply-To: <20080305122010.GA999@elte.hu>
Message-ID: <Pine.LNX.4.58.0803051331550.1188@pc-041.diku.dk>
References: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk>
 <20080305063842.GA24495@elte.hu> <70318cbf0803042249j57d7f3a3j7666961a9132b10b@mail.gmail.com>
 <20080305070201.GA32434@elte.hu> <Pine.LNX.4.64.0803050951550.28021@ask.diku.dk>
 <20080305122010.GA999@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Ingo Molnar wrote:

>
> * Julia Lawall <julia@diku.dk> wrote:
>
> > There are some legitimate uses of !x & y which are actually of the
> > form !x & !y, where x and y are function calls.  That is a not
> > particularly elegant way of getting both x and y to be evaluated and
> > then combining the results using "and".  If such code is considered
> > acceptable, then perhaps the sparse patch should be more complicated.
>
> i tend to be of the opinion that the details in C source code should be
> visually obvious and should be heavily simplified down from what is
> 'possible' language-wise - with most deviations and complications that
> depart from convention considered an error. I'd consider "!fn1() &
> !fn2()" a borderline coding style violation in any case - and it costs
> nothing to change it to "!fn1() && !fn2()".

!fn1() && !fn2() does not have the same semantics as !fn1() & !fn2().  In
!fn1() & !fn2() both function calls are evaluated.  In !fn1() && !fn2(),
if !fn1() returns false then !fn2() is not evaluated.  I haven't studied
the particular instances of fn2(), though, to know whether it makes a
difference.

One could instead do something like:

x = fn1();
y = fn2();
if (!x && !y) ...

It would certainly be clearer, but more verbose.

julia

