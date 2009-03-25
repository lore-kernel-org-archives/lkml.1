Return-Path: <linux-kernel-owner+w=401wt.eu-S1762608AbZCYPUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762608AbZCYPUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbZCYPT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:19:56 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:41542 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756691AbZCYPTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:19:54 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net B51162C2F5A
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Linux 2.6.29
To: Theodore Tso <tytso@mit.edu>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Wed, 25 Mar 2009 16:19:50 +0100
References: <cj1Ut-1i2-7@gated-at.bofh.it> <cj8ji-35a-5@gated-at.bofh.it> <cj8CC-3uO-5@gated-at.bofh.it> <cjaXP-7vB-17@gated-at.bofh.it> <cjbhc-7VP-13@gated-at.bofh.it> <cjbTS-AR-11@gated-at.bofh.it> <cjcdl-10E-31@gated-at.bofh.it> <cjeS0-5nC-33@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LmUtS-0001dx-DS@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> wrote:

> OK, so there are a couple of solutions to this problem.  One is to use
> ext4 and delayed allocation.  This solves the problem by simply not
> allocating the blocks in the first place, so we don't have to force
> them out to solve the security problem that data=ordered was trying to
> solve.  Simply mounting an ext3 filesystem using ext4, without making
> any change to the filesystem format, should solve the problem.

[...]

> However, these days, nearly all Linux boxes are single user machines,
> so the security concern is much less of a problem.  So maybe the best
> solution for now is to make data=writeback the default.  This solves
> the problem too.  The only problem with this is that there are a lot
> of sloppy application writers out there, and they've gotten lazy about
> using fsync() where it's necessary;

The problem is not having accidential data loss because the inode /happened/
to be written before the data, but having /guaranteed/ data loss in a
60-seconds-window. This is about as acceptable as having a filesystem
replace _any_ data with "deadbeef" on each crash unless fsync was called.

Besides that: If the problem is due to crappy VM writeout (is it?), reducing
security to DOS level is not the answer. You'd want your fs to be usable on
servers, wouldn't you?

