Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYFRQ6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYFRQ6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYFRQ5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:57:53 -0400
Received: from [213.77.9.205] ([213.77.9.205]:63905 "EHLO serum.com.pl"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751271AbYFRQ5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:57:53 -0400
Date: Wed, 18 Jun 2008 17:54:32 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: nmi_watchdog suspicious
In-Reply-To: <20080618163905.GB7117@cvg>
Message-ID: <Pine.LNX.4.55.0806181749050.4857@cliff.in.clinika.pl>
References: <20080610185759.GA7353@cvg> <Pine.LNX.4.55.0806160040270.11995@cliff.in.clinika.pl>
 <20080616170000.GC7273@cvg> <Pine.LNX.4.55.0806161819500.20218@cliff.in.clinika.pl>
 <20080617155120.GA9440@cvg> <Pine.LNX.4.55.0806181654450.4857@cliff.in.clinika.pl>
 <20080618163905.GB7117@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008, Cyrill Gorcunov wrote:

> Maciej, it seems we are talking about different code snippets ;)
> I'm talking only about touch_nmi_watchdog(). By now (in -tip tree
> we have)
> 
> void touch_nmi_watchdog(void)
> {
> 	if (nmi_watchdog == NMI_LOCAL_APIC ||
> 		nmi_watchdog == NMI_IO_APIC) {
> 		unsigned cpu;
> 		...
> 
> so we check explicitly the values (so if touch_nmi_watchdog
> was called when nmi_watchdog = 0 or -1U this code will not
> be executed anyway). So I think I'm a bit lost, Maciej... I just
> can't figure out what is wrong with this code, so please help
> me ;). If you're talking about apic code in _general_ design
> then...well, I think I need some time to _understand_ the code
> say byte-by-byte first.

 The value of nmi_watchdog being NMI_IO_APIC or NMI_LOCAL_APIC does not 
mean the watchdog has been set up already.  This observation applies both 
here and elsewhere, e.g. to nmi_watchdog_tick().

  Maciej
