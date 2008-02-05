Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbYBEQGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbYBEQGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbYBEQGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:06:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56499 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbYBEQGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:06:39 -0500
Date: Tue, 5 Feb 2008 17:06:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       Jiri Kosina <jkosina@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Abel Bernabeu <abel.bernabeu@gmail.com>
Subject: Re: brk randomization breaks columns
Message-ID: <20080205160620.GA28812@elte.hu>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz> <Pine.LNX.4.64.0802051243240.542@blonde.site> <20080205070001.7bc8058f@laptopd505.fenrus.org> <20080205154648.GA24331@elf.ucw.cz> <20080205154953.GA26829@elte.hu> <20080205155959.GC24331@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205155959.GC24331@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> . Yes, setarch i386 -R /usr/local/bin/uemacs (etc) fixes them, too.
> 	
> What about this?
> 
> Heap randomization breaks /lib/libc.so.5.4.33, make it possible to 
> randomize normal stuff but leave the heap alone.

certainly looks fine to me, but please also add a .config to make it 
default to 2. The reason is that a good portions of the overflows happen 
on the heap and 99.9% of the Linux users do not run 1996-era glibc 
anymore.

something like CONFIG_COMPAT_BRK=y, which would cause randomize_va_space 
to default to 1, and if a user or distro disables it, it will default to 
2.

	Ingo
