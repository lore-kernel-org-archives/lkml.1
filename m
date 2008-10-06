Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbYJFX7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbYJFX7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYJFX7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:59:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56520 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbYJFX7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:59:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Kees Cook <kees.cook@canonical.com>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
In-Reply-To: Kees Cook's message of  Monday, 6 October 2008 15:07:59 -0700 <20081006220759.GM10357@outflux.net>
References: <20081001201116.GD12527@outflux.net>
	<48E3EFD6.2010704@redhat.com>
	<20081001215657.GH12527@outflux.net>
	<20081001220948.GC32107@sunsite.ms.mff.cuni.cz>
	<20081001222706.68E7E1544B4@magilla.localdomain>
	<20081003001616.GN10632@outflux.net>
	<87ej2untze.fsf@basil.nowhere.org>
	<20081006175038.GF10357@outflux.net>
	<20081006192641.GI3180@one.firstfloor.org>
	<20081006220759.GM10357@outflux.net>
X-Shopping-List: (1) Industrious inhibition cheater-hawks
   (2) Lesser-known bags
   (3) Specious aristocratic hands
Message-Id: <20081006235827.59306154271@magilla.localdomain>
Date: Mon,  6 Oct 2008 16:58:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What mmap randomization and stack randomization actually use is
get_random_int(), not get_random_bytes().  This is one of those weaker
flavors seeded occasionally from the real entropy pool.  (As is, it's not a
good choice for getting 16 bytes of random at once, since it usually
returns the same 4 bytes each time when called 4 times in quick succession.)

What glibc wants is some bits with a strength of randomness chosen by the
kernel, and not to worry about the details.  I think the strength applied
to mmap and stack randomization is good enough for AT_RANDOM.


Thanks,
Roland
