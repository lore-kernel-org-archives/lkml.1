Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYLaSaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYLaSaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYLaSaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:30:01 -0500
Received: from waste.org ([66.93.16.53]:33146 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921AbYLaSaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:30:00 -0500
Subject: random.c changes for sparse irq_desc are crap
From: Matt Mackall <mpm@selenic.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 12:29:29 -0600
Message-Id: <1230748169.19620.132.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed you merged a change that pointlessly converts two
random.c functions into ugly random.h inlines without going through the
maintainer.

I also don't like the look of the newly-introduced sparse variants of
these functions. Failure to find an irq descriptor in
get_timer_rand_state is a BUG_ON should-never-happen sort of condition,
not something to silently ignore. Letting the code try to dereference
NULL is preferred here: we'll actually be able to find and fix the
broken driver that's throwing around meaningless irq vectors.

Throwing away the timer_state pointer in the set_timer_rand_state
function is similarly bogus in addition to being a memory leak.

Please fix this up.

-- 
Mathematics is the supreme nostalgia of our time.

