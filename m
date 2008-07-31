Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYGaOGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYGaOGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYGaOGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:06:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52796 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYGaOGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:06:40 -0400
Date: Thu, 31 Jul 2008 16:06:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Bert Wesarg <bert.wesarg@googlemail.com>,
       Tejun Heo <htejun@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PULL] typesafe callbacks for kthread and stop_machine
Message-ID: <20080731140643.GO23938@one.firstfloor.org>
References: <200807311452.36025.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807311452.36025.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 02:52:35PM +1000, Rusty Russell wrote:
> Just the two places I look after.  And this time the conglomerate patch is
> included below for more random commentry.

I must say I personally don't like the wrapper macros that you require
for each function that uses this. A wrapper macro has a large impact
on code readability because everyone following a call chain has
to do an additional grep/open file etc. step. I have my doubts not having casts 
outweights that disadvantage.

I know that gcc has this funky transparent union extension that
glibc socket() uses to allow different address types without casts.
It has the advantage of not needing wrapper macros. Any chance of 
using that instead? Or has that one been considered already and
discarded? 

-Andi
