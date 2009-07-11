Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbZGKH5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbZGKH5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 03:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZGKH51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 03:57:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZGKH51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 03:57:27 -0400
Date: Sat, 11 Jul 2009 09:57:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <roland@digitalvampire.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove spurious printk level from segfault message
Message-ID: <20090711075721.GA8295@elte.hu>
References: <874otjitkj.fsf@shaolin.home.digitalvampire.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874otjitkj.fsf@shaolin.home.digitalvampire.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland Dreier <roland@digitalvampire.org> wrote:

> Since commit 5fd29d6c ("printk: clean up handling of log-levels and
> newlines"), the kernel logs segfaults like:
> 
>     <6>gnome-power-man[24509]: segfault at 20 ip 00007f9d4950465a sp 00007fffbb50fc70 error 4 in libgobject-2.0.so.0.2103.0[7f9d494f7000+45000]
> 
> with the extra "<6>" being KERN_INFO.  This happens because the printk
> in show_signal_msg() started with KERN_CONT and then used "%s" to pass
> in the real level; and KERN_CONT is no longer an empty string, and
> printk only pays attention to the level at the very beginning of the
> format string.
> 
> Therefore, remove the KERN_CONT from this printk, since it is now
> actively causing problems (and never really made any sense).

Indeed, this particular KERN_CONT never made any sense. It's good it 
has some active role now. Applied to tip:x86/urgent, thanks Roland.

	Ingo
