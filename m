Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbYCVWCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbYCVWCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYCVWCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:02:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58070 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbYCVWCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:02:09 -0400
Message-ID: <47E5815B.4080002@kernel.org>
Date: Sat, 22 Mar 2008 14:59:55 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Thomas Meyer <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Ingo/Thomas - should ioremap*() perhaps take "resource_size_t" or a "u64" 
> for the address (and then "__ioremap()" should probably take a PFN, not a 
> physical address, and that one can remain just a "unsigned long"?)
> 

resource_size_t seems to make sense here.  In the case when we have 
64-bit resources but no PAE support we should error our when the 
resource is out of range rather than silently fail.

> Has anybody ever had a working 64-bit BAR on x86? Ivan? Maybe I'm missing 
> something..

64-bit BAR, certainly.  64-bit BAR with a value beyond 4 GB I would find 
questionable at best... I suspect the answer is "no".

	-hpa


