Return-Path: <linux-kernel-owner+w=401wt.eu-S932241AbXCEU2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbXCEU2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932255AbXCEU2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:28:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37002 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241AbXCEU2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:28:16 -0500
Date: Mon, 5 Mar 2007 21:26:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] disable NMI watchdog by default
Message-ID: <20070305202648.GA2184@elte.hu>
References: <20070305122011.GA16133@elte.hu> <200703051242.45635.lenb@kernel.org> <200703052054.45292.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703052054.45292.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> > There are multiple machines not booting because of nmi_watchdog.
> > Some of them are documented here:
> > http://bugzilla.kernel.org/show_bug.cgi?id=7839
> > 
> > We used to think this was the "nolapic" bug,
> > but it is actually the "nmi_watchdog=0" bug.
> 
> I thought that one was worked around by Ingo's patch to not do nmi 
> watchdog during ACPI methods, wasn't it?

unfortunately that only made the lockups on my laptop rarer, it didnt 
totally solve it. My workaround was only done for init acpi methods 
(bootup) - it was getting really ugly when i tried to extend it to all 
ACPI execution. I'd guess the situation on those other systems is 
similar.

Maybe we could take only the 32-bit side of my patch, because that's 
what is most affected by legacies. Although i suspect Windows still 
doesnt inject NMIs in 64-bit mode either, so i dont think there's any 
fundamental difference in terms of breakage in the future, it's just 
that 64-bit systems and 64-bit testing is 1:5 - 1:10 rarer than 32-bit 
testing.

dunno. A distro can still patch the NMI watchdog on, easily. If you 
think it's a better approach i can make this a .config option - just 
like CONFIG_DETECT_SOFTLOCKUP: CONFIG_DETECT_HARDLOCKUP, which would 
default to off?

	Ingo
