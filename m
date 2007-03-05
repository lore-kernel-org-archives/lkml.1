Return-Path: <linux-kernel-owner+w=401wt.eu-S1751236AbXCEUpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbXCEUpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbXCEUpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:45:43 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36074 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbXCEUpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:45:41 -0500
Date: Mon, 5 Mar 2007 12:40:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <ak@suse.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] disable NMI watchdog by default
In-Reply-To: <20070305202648.GA2184@elte.hu>
Message-ID: <Pine.LNX.4.64.0703051236450.3998@woody.linux-foundation.org>
References: <20070305122011.GA16133@elte.hu> <200703051242.45635.lenb@kernel.org>
 <200703052054.45292.ak@suse.de> <20070305202648.GA2184@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Mar 2007, Ingo Molnar wrote:
> 
> Maybe we could take only the 32-bit side of my patch, because that's 
> what is most affected by legacies. Although i suspect Windows still 
> doesnt inject NMIs in 64-bit mode either, so i dont think there's any 
> fundamental difference in terms of breakage in the future, it's just 
> that 64-bit systems and 64-bit testing is 1:5 - 1:10 rarer than 32-bit 
> testing.

I really don't see the point of having NMI on by default. Debugging that 
can cause problems should be disabled. I thought we disabled this a long 
time ago -  but anyway, now it *really* is (ie I applied your patch).

Anybody who thinks that debugging code is always good is deluded. 
Debugging is only good if it has zero downsides and doesn't introduce 
problems of its own. And the NMI watchdog clearly isn't in that camp.

If you *actively* debug stuff and/or have actually seen lockups, use the 
NMI watchdog. But last I saw, if the machine was running X, the NMI 
watchdog wouldn't help *anyway*, so enabling it by default

 - has almost zero upsides in the wild _anyway_

 - clearly has risks.

so this was a no-brainer. I don't understand why it's even discussed, or 
why I hadn't gotten the patch the last time this was discussed.

		Linus
