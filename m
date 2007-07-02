Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbXGBKWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbXGBKWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 06:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbXGBKV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 06:21:59 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:42496 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbXGBKV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 06:21:58 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 2 Jul 2007 06:20:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap@sources.redhat.com
Subject: Re: instrumentation and kprobes really still "EXPERIMENTAL"?
In-Reply-To: <863e9df20707020256m75d24f52yfc5acd78cacffac7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707020619590.29879@localhost.localdomain>
References: <Pine.LNX.4.64.0707011204580.32355@localhost.localdomain> 
 <863e9df20707020154o5232e44ch37dd55811c377a8f@mail.gmail.com> 
 <Pine.LNX.4.64.0707020512320.26135@localhost.localdomain>
 <863e9df20707020256m75d24f52yfc5acd78cacffac7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007, Abhishek Sagar wrote:

> On 7/2/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> > On Mon, 2 Jul 2007, Abhishek Sagar wrote:
> >
> > > On 7/1/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> > > > isn't kprobes mature enough to not be considered experimental anymore?
> > >
> > > That would vary from arch to arch.
> >
> > fair enough.  however, at the very least, i'm thinking that the entire
> > "Instrumentation support" submenu can be made non-EXPERIMENTAL, while
> > individual entries therein can be EXPERIMENTAL on a choice-by-choice
> > basis or something like that.
>
> There's not a lot in that menu. It holds oprofile on every arch I
> grepped on. Oprofile might come across as being marked
> non-experimental but that may very well be due to the assumption
> that the menu that holds that option will enforce the EXPERIMENTAL
> check.

consider this random Kconfig file arch/x86_64/oprofile/Kconfig:

=============================
config PROFILING
        bool "Profiling support (EXPERIMENTAL)"
        help
          Say Y here to enable the extended profiling support mechanisms used
          by profilers such as OProfile.


config OPROFILE
        tristate "OProfile system profiling (EXPERIMENTAL)"
        depends on PROFILING
        help
          OProfile is a profiling system capable of profiling the
          whole system, include the kernel, kernel modules, libraries,
          and applications.

          If unsure, say N.
==============================

  the above is a bit silly.  note that both prompts advertise
themselves as "EXPERIMENTAL" even though neither of them has such a
dependency.  they *are*, however, part of an submenu that *is*
dependent on EXPERIMENTAL (although you'd never know that just by
looking at that Kconfig file).  in short, it's just kind of ugly
hackery at the moment.

  i made a suggestion a while back about having maturity levels like
"EXPERIMENTAL" **automatically** added to the displayed prompts when
you're doing a config -- that would go a long way to avoiding all this
manual adding of a maturity level to Kconfig prompts, but that's a
non-trivial change and is something the Kconfig folks would have to
handle.

  my original point was simply that, based on its acceptance, it would
seem kprobes has progressed beyond the EXPERIMENTAL phase, that's all.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
