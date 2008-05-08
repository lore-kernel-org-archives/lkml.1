Return-Path: <linux-kernel-owner+w=401wt.eu-S1765715AbYEHSba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765715AbYEHSba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756359AbYEHSbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:31:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755045AbYEHSbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:31:16 -0400
Date: Thu, 8 May 2008 11:30:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix AIM7
 40% regression with 2.6.26-rc1)
In-Reply-To: <alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805081128550.3024@woody.linux-foundation.org>
References: <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org>
 <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu>
 <alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Linus Torvalds wrote:
> 
> Why don't we just make it do the same thing that the x86 semaphores used 
> to do: make it signed, and decrement unconditionally. And callt eh 
> slow-path if it became negative.
> ... 
> and now we have an existing known-good implementation to look at?

Ok, after having thought that over, and looked at the code, I think I like 
your version after all. The old implementation was pretty complex due to 
the need to be so extra careful about the count that could change outside 
of the lock, so everything considered, a new implementation that is 
simpler is probably the better choice.

Ergo, I will just pull your scheduler tree.

			Linus
