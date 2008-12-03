Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYLCCDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYLCCDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 21:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYLCCDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 21:03:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbYLCCDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 21:03:21 -0500
Date: Tue, 2 Dec 2008 18:02:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812030222.28551.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812021751450.3256@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812030100.18400.rjw@sisk.pl> <alpine.LFD.2.00.0812021608520.3256@nehalem.linux-foundation.org> <200812030222.28551.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Dec 2008, Rafael J. Wysocki wrote:
> 
> Here's the output of 'lspci -vvxxx':

Ok, I'm not finding any documented quirks that would be memory regions, 
and in fact it doesn't look like there is even any remotely likely 32-bit 
valies that might be pointers in your PCI config space that look remotely 
like they might be conflicting in the area of MMIO space that we allocate 
PCI resources from (ie 0x88000000-0x92000000).

Of course, any odd MMIO regions might be descibed by some insane model 
that doesn't look like an aligned 32-bit value, but that's unlikely.

So I'm still not seeing anything wrong in there.

> I'll run the 'pci=cbmemsize=4M' test tomorrow (need to have some sleep).

Sure. It will be interesting to see if it makes any difference.

		Linus
