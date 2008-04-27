Return-Path: <linux-kernel-owner+w=401wt.eu-S1763827AbYD0Ul4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763827AbYD0Ul4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYD0Uls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:41:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50646 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbYD0Ulr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:41:47 -0400
Date: Sun, 27 Apr 2008 22:41:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: find_new_bit bloat from x86 tree...
Message-ID: <20080427204129.GB25300@elte.hu>
References: <20080426.220726.13692428.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.220726.13692428.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Miller <davem@davemloft.net> wrote:

> Ingo, what the heck is this?
> 
> commit 64970b68d2b3ed32b964b0b30b1b98518fde388e
> Author: Alexander van Heukelum <heukelum@mailshack.com>

(Alexander Cc:-ed.)

> Date:   Tue Mar 11 16:17:19 2008 +0100
> 
>     x86, generic: optimize find_next_(zero_)bit for small constant-size bitmaps
> 
> Thanks for bloating up the inline expansion of this thing on every 
> architecture that doesn't do __ffs() in a simple sequence of a few 
> instructions like x86 does.

ok, that's bad. How much is the before/after vmlinux btw, i guess you 
measured it? We could either make it per arch selectable, or we could 
just uninline it all. It shouldnt be a big deal on x86 and it should 
help on RISC platforms.

	Ingo
