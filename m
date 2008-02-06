Return-Path: <linux-kernel-owner+w=401wt.eu-S1762383AbYBFJvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762383AbYBFJvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 04:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762222AbYBFJvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 04:51:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40479 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759014AbYBFJv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 04:51:29 -0500
Date: Wed, 6 Feb 2008 10:51:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Pavel Emelyanov <xemul@openvz.org>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com,
       john.ronciak@intel.com, David Miller <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net, Denis Lunev <den@openvz.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_32: fix regression caused by trim ram according to
	mtrr on system with 4G more RAM
Message-ID: <20080206095107.GA30596@elte.hu>
References: <47A89A77.1050608@openvz.org> <200802060119.25278.yinghai.lu@sun.com> <47A97E28.1010400@openvz.org> <200802060149.26083.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802060149.26083.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86_32: fix regression caused by trim ram according to mtrr on system with 4G more RAM
> 
> Pravel report:
> "
> The commit
> 
>         093af8d7f0ba3c6be1485973508584ef081e9f93
>         x86_32: trim memory by updating e820
> 
> broke my e1000 card: on loading driver says that
> 
>         e1000: probe of 0000:04:03.0 failed with error -5
> 
> and the interface doesn't appear.
> "
> 
> on 32 bit kernel, base will overflow when try to do PAGE_SHIFT. and 
> highest_addr will always less 4G.
> 
> so use pfn instead of address to avoid overflow when more than 4g
>  ram installed on 32bit kernel
> Many thanks for Pavel Emelyanov to report and test it.

thanks guys, applied.

	Ingo
