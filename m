Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbYFWSh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbYFWSh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbYFWShQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:37:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755137AbYFWShP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:37:15 -0400
Date: Mon, 23 Jun 2008 11:32:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Hugh Dickins <hugh@veritas.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@tv-sign.ru>, Nick Piggin <npiggin@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Subject: Re: [patch 2/5] Reinstate ZERO_PAGE optimization in get_user_pages()
 and fix XIP
In-Reply-To: <b6a2187b0806231115t55bf58cfgdc27a2d265258aab@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0806231129410.2926@woody.linux-foundation.org>
References: <20080622185327.348377223@mini.kroah.org>  <20080622190140.GD20141@suse.de>  <alpine.LFD.1.10.0806221220530.2926@woody.linux-foundation.org>  <20080622202950.GB20800@suse.de>  <b6a2187b0806230832j10e8be28vc0b05fea233437fa@mail.gmail.com> 
 <Pine.LNX.4.64.0806231650190.13651@blonde.site>  <alpine.LFD.1.10.0806230928140.2926@woody.linux-foundation.org>  <b6a2187b0806231005x44b69918q111e865938c55e7@mail.gmail.com>  <alpine.LFD.1.10.0806231022300.2926@woody.linux-foundation.org>
 <b6a2187b0806231115t55bf58cfgdc27a2d265258aab@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jun 2008, Jeff Chua wrote:

> On Tue, Jun 24, 2008 at 1:27 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> 
> > On the other hand, if you add a trace to the "use_zero_page()" function to
> > print out the vm_flags and other details, that probably would help.
> 
> Let me know if you still want me to test this.

No, it's fine. It really was a bug, and a long-standing one, just one that 
was probably practically impossible to hit before (because we used to only 
do the FOLL_ANON logic on missing whole page tables, and just about any 
access to any mapping even nearby the one you care about will fill in the 
page tables - so you would have had to be really unlucky to trigger the 
case before).

The patch clearly fixes an issue, and makes the code more readable and 
maintainable too, so I don't care what the exact mapping flags etc were.

> Yeh, it works great! Thank you.

Thanks for bisecting, reporting and testing. 

			Linus
