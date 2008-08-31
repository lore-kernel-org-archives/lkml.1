Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYHaRoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYHaRoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbYHaRoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:44:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbYHaRn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:43:59 -0400
Date: Sun, 31 Aug 2008 10:42:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <200808311427.19369.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0808311039330.12958@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <200808302334.29156.rjw@sisk.pl> <86802c440808301810r17657f3fnb3c8af5496955e0d@mail.gmail.com> <200808311427.19369.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 31 Aug 2008, Rafael J. Wysocki wrote:
> 
> Works, dmesg is at:
> http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/2.6.27-rc5-test.log

That BAR is indeed "locked". Now that we try to reallocate it, you get 
this in the log:

	pci 0000:00:00.0: BAR 3: error updating (0x40000004 != 0xe0000004)
	pci 0000:00:00.0: BAR 3: error updating (high 0x000001 != 0x000000)

ie now the code _tried_ to update the BAR to point to 0x1_4000_0000 
instead, but the hardware refused, and it is still at 0x0_e000_0000.

So Yinghai's patch "worked", but it worked by doing nothing.

See my earlier guess about locked read-only resources a few emails back. 
IOW, I'm not at all surprised. I really do suspect that that BAR is some 
very special "this is the HT->PCIE region" BAR.

			Linus
