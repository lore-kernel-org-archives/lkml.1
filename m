Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYFOXuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYFOXuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 19:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYFOXt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 19:49:59 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61376 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751471AbYFOXt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 19:49:58 -0400
Date: Mon, 16 Jun 2008 00:49:00 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: nmi_watchdog suspicious
In-Reply-To: <20080610185759.GA7353@cvg>
Message-ID: <Pine.LNX.4.55.0806160040270.11995@cliff.in.clinika.pl>
References: <20080610185759.GA7353@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Cyrill Gorcunov wrote:

> On 64bit mode nmi_watchdog=NMI_NONE by default (in case if APIC enabled).
> On 32bit mode nmi_watchdog=NMI_DEFAULT was by default (in any case,
> but could be set to NMI_NONE in check_timer(), but we don't take
> this case now).

 I haven't tracked the 64-bit port, but for plain i386 the watchdog used
to be on by default, then proved problematic with too many broken pieces
of equipment (typically because of bugs in the SMM firmware) and thus set
to off.

> So lets take a look on touch_nmi_watchdog().
> There is the condition
> 
> 	if (nmi_watchdog > 0)
> 		...tell to reset counters in nmi_watchdog_tick()
> 
> this condition is not taken on 64bit mode, but *was* taken on
> 32bit mode by default! So who was right then? 64bit version or 32bit?
> 
> Maciej, could you take a look please? Maybe I just missing figure
> in general - ie how nmi_watchdog _should_ work.

 Well, values >= NMI_INVALID are never used, so the condition is correct.  
It is meant to be positive whenever a working watchdog has been selected.  
Obviously nmi_watchdog should be a signed int though, so there is a bug
there.  You better audit all the uses of the variable...

  Maciej
