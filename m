Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbXLIWcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbXLIWcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbXLIWcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 17:32:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51690 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbXLIWcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 17:32:02 -0500
Date: Sun, 9 Dec 2007 14:30:59 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Message-ID: <20071209143059.7128abf5@laptopd505.fenrus.org>
In-Reply-To: <82e4877d0712091357u41973a24v38c4ad18ad596de5@mail.gmail.com>
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	<20071208191330.GA21186@elte.hu>
	<82e4877d0712081133y49fec9bfyee30a3010b37c435@mail.gmail.com>
	<20071208194211.GA579@elte.hu>
	<82e4877d0712081208u335c968csd1d3e9259cdd2920@mail.gmail.com>
	<20071208201137.GA13451@elte.hu>
	<82e4877d0712081246x4d788c36i908916185611fa94@mail.gmail.com>
	<20071208125144.734e9f81@laptopd505.fenrus.org>
	<82e4877d0712081304r19721b43w78b294ea8d470405@mail.gmail.com>
	<82e4877d0712081512s2b5a72aewbe396f28305ac963@mail.gmail.com>
	<82e4877d0712091357u41973a24v38c4ad18ad596de5@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007 16:57:38 -0500
"Parag Warudkar" <parag.warudkar@gmail.com> wrote:

> On Dec 8, 2007 6:12 PM, Parag Warudkar <parag.warudkar@gmail.com>
> wrote:
> > No problems after disabling CONFIG_HIGHRES_TIMERS , CONFIG_CPU_IDLE
> > and CONFIG_NO_HZ.
> >
> > I will try enabling them one by one - HRT, NOHZ and CPU_IDLE last -
> > that way we can at least tell what is required to be hit with this
> > problem.
> 
> Looks like CPU_IDLE=y is necessary for the problem to show up.
> With CPU_IDLE=n HRT+NO_HZ+TICK_ONESHOT does not give soft lockup
> problems. (Actually with HIGH_RES_TIMERS=NO_HZ=TICK_ONESHOT=y  I do
> see short freezes on ssh - when I cannot type anything for may be a
> second even under 100% idle. But Soft Lock up doesnt show up in dmesg
> with this configuration.)


starts to sound like something is turning off the clock during a somewhat deeper C-state...
