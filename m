Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYFUB45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYFUB45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 21:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYFUB4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 21:56:49 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64244 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750948AbYFUB4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 21:56:48 -0400
Date: Sat, 21 Jun 2008 02:54:38 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: nmi_watchdog suspicious
In-Reply-To: <20080618172316.GA10431@cvg>
Message-ID: <Pine.LNX.4.55.0806210250210.19614@cliff.in.clinika.pl>
References: <20080610185759.GA7353@cvg> <Pine.LNX.4.55.0806160040270.11995@cliff.in.clinika.pl>
 <20080616170000.GC7273@cvg> <Pine.LNX.4.55.0806161819500.20218@cliff.in.clinika.pl>
 <20080617155120.GA9440@cvg> <Pine.LNX.4.55.0806181654450.4857@cliff.in.clinika.pl>
 <20080618163905.GB7117@cvg> <Pine.LNX.4.55.0806181749050.4857@cliff.in.clinika.pl>
 <20080618172316.GA10431@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008, Cyrill Gorcunov wrote:

> If you mean the case we get NMI physical line assetred while configuring APIC
> (ie nmi watchdog is not properly configured yet) then I wonder why we has
> this checking at all...

 Hmm, I am not sure what you mean -- nmi_watchdog_tick() can be called
potentially at any time, and you can receive NMIs from sources other than
the watchdog; the latters would set bits in the Port B at 0x61 in most
cases though.  Anyway using a separate variable such as
"nmi_watchdog_active" would be cleaner.

  Maciej
