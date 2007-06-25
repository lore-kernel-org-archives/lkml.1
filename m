Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbXFYEno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbXFYEno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 00:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbXFYEng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 00:43:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55583 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbXFYEng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 00:43:36 -0400
Subject: Re: [PATCH] get_random_long() and AT_ENTROPY for auxv, kernel
	2.6.21.5
From: Arjan van de Ven <arjan@infradead.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Alexander Gabert <pappy@gentoo.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, libc-alpha@sourceware.org,
       hardened@gentoo.org
In-Reply-To: <20070625034508.GE11115@waste.org>
References: <4675C678.3080807@gentoo.org>
	 <1182128803.22999.9.camel@laptopd505.fenrus.org>
	 <20070620203022.GO11166@waste.org> <467EADA0.9020101@gentoo.org>
	 <20070625034508.GE11115@waste.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 24 Jun 2007 21:43:03 -0700
Message-Id: <1182746583.26621.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-24 at 22:45 -0500, Matt Mackall wrote:
> On Sun, Jun 24, 2007 at 07:45:04PM +0200, Alexander Gabert wrote:
> > Hi Linus,
> > hi LKML,
> > 
> > i would like to thank LKML and especially Eric (thanks for the per_cpu 
> > macro tips and design guidelines!) and the other contributors to this idea.
> > 
> > This time the patch is rather big because it also removes 
> > get_random_int() and introduces get_random_long() throughout the kernel.
> 
> Stop right there. You still haven't answered my original question.
> What is the point of this exercise in the first place, please?
> 
> Am I right in thinking you have three unrelated patches here?
> 
> - something to do with aux vector headers

the primary goal is to pass a random value to userspace at process
start; this to save glibc from having to open /dev/urandom on ever
program start (which it does now for all apps compiled with
-fstack-protector, which in various distros is "everything").

> - sweeping change of get_random_int to get_random_long for no obvious reason

and this is because Alexander wants 2 and not 1 random int to be passed
for his own glibc proposed change (combined with get_random_int() being
designed for only 4 bytes per process ;-)

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

