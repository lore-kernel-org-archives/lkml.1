Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbYHMTyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbYHMTyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbYHMTx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:53:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:53698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025AbYHMTx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:53:58 -0400
From: Andreas Schwab <schwab@suse.de>
To: David Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc3
References: <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org>
X-Yow: I'm ZIPPY the PINHEAD and I'm totally committed to the festive mode.
Date: Wed, 13 Aug 2008 21:53:56 +0200
In-Reply-To: <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Tue, 12 Aug 2008 19:33:16 -0700 (PDT)")
Message-ID: <jefxp8ofmz.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> David Miller (3):
>       lockdep: fix combinatorial explosion in lock subgraph traversal

lockdep_count_forward_deps is only defined if CONFIG_PROVE_LOCKING but
used unconditionally in lockdep_proc.c.

kernel/built-in.o: In function `.lockdep_stats_show':
lockdep_proc.c:(.text+0x3fea8): undefined reference to `.lockdep_count_forward_deps'
kernel/built-in.o: In function `.l_show':
lockdep_proc.c:(.text+0x401f0): undefined reference to `.lockdep_count_forward_deps'
lockdep_proc.c:(.text+0x40210): undefined reference to `.lockdep_count_backward_deps'

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
