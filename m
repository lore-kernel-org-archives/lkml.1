Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYLEC4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYLEC4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 21:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYLEC4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 21:56:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbYLEC4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 21:56:03 -0500
Date: Thu, 4 Dec 2008 18:55:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <alpine.LFD.2.00.0812041724130.3543@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0812041845210.3543@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041545130.3543@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812041645290.3543@nehalem.linux-foundation.org> <200812050208.33827.rjw@sisk.pl>
 <alpine.LFD.2.00.0812041724130.3543@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Dec 2008, Linus Torvalds wrote:
> 
> NOTE NOTE NOTE! I didn't check which all LPC bridges there are out there 
> that have these magic registers. But it shows up in the ICH7 docs. It 
> migth exist in ICH[5-9] for all I know. But at least for ICH7, the only 
> LPC bridge ID's I find in the spec update are 27b8, 27b9 and 27bd, which 
> are those three devices that I list in the quirks.

Ok, the ICH6 LPC side has something similar, but not the same. Just two 
ranges, and slightly less flexible wrt sizing.

And ICH8/9/10 seems to have the same thing as ICH7.

And looking at my own machine (ICH10) it actually appears like my ICH10 
setup has two of the magic IO ranges that it decodes, and only one of them 
is covered by the BIOS PnP tables.

They're both below 0x1000, though, so Linux shouldn't ever allocate 
anything on top of them. And that's the norm - when firmware sets up 
hidden magic system IO ranges, they do tend to be low IO ports.

But if some incompetent firmware person screws that up...

		Linus
