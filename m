Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZGCIOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZGCIOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZGCIOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:14:24 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:40528 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZGCIOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:14:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=od5wvBqOUH5BVktSH53AtBdGj/lqig6vjme5nhl4W78CPB9ybOTALbgux+KLk9Vb+5
         l/Nu8qyyBMnNTeqCoX92OB7OMd0eTed3YS+lsw+/ge21uQdBjQhG2Pu+kyba/qe6DPUF
         PYC92AYye7Eh1UBPQ7wYxvP3WQtLjF4lYBhio=
MIME-Version: 1.0
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 3 Jul 2009 04:14:05 -0400
Message-ID: <8bd0f97a0907030114g459863e9l829a6291e990b9cf@mail.gmail.com>
Subject: making asm-generic/futex.h completely usable
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ive been reading up on futexes of late and have been poking around the
futex kernel pieces to see what is needed to get Blackfin working with
it.

Blackfin falls into the "no hardware atomic instructions" category as
can easily be seen in our atomic.h: disable interrupts, do
load/stores, restore interrupts.  my understanding of the
futex_atomic_op_inuser() function is that this runs in process
context, so this same interrupt trick should work fine.  which leads
me to wonder why doesnt the asm-generic/futex.h header already take
this approach ?

seems to me that the SuperH implementation fits the bill nicely.
their arch/sh/include/asm/futex-irq.h looks like it could be literally
straight copied into asm-generic/futex.h thus making it fully
functional for everyone by default.

also, the futex_atomic_op_inuser() function itself seems to largely be
copy & paste between architectures ... the only differences are in the
atomic functions called by FUTEX_OP_XXX.  so perhaps the structure of
the header should follow that of asm-generic/uaccess.h in that arches
can override specific functions while still getting the rest for free
?
-mike
