Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbYGNGkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbYGNGkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 02:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbYGNGkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 02:40:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42680 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYGNGkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 02:40:01 -0400
Message-ID: <487AF4BB.6050805@firstfloor.org>
Date: Mon, 14 Jul 2008 08:39:55 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807080143.27997.yhlu.kernel@gmail.com> <200807092015.03004.yhlu.kernel@gmail.com> <20080710071640.5035cd70@infradead.org> <874p6t25n5.fsf@basil.nowhere.org> <86802c440807131117g3ba9e61chea61af81b7537bb0@mail.gmail.com> <487A4DFC.5090701@firstfloor.org> <20080713203250.GA6925@elte.hu> <487A6AD0.5000506@firstfloor.org> <487A9804.8090307@zytor.com>
In-Reply-To: <487A9804.8090307@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Andi Kleen wrote:
>>
>> First I was only commenting on one specific patch, nothing more.
>>
>> My point is full rounding to 4K on all corners is wasteful because the
>> CPUs have to handle that case anyways and every split costs precious
>> TLB entries in direct mapping accesses.
>>
> 
> Well, the CPU *does* handle them... by splitting the larger pages into
> smaller pages.  They still end up in the small-page TLB, so there is no
> real difference if done in the CPU or in software.

There's actually a difference in some cases, but that's a different
issue.

Only when the hole is a real hole. But when it's just some firmware
area or similar that's not needed.

> Memory state transitions are (fortunately) relatively rare and
> long-lived,

That's not true today with several 3d driver setups. Also in general
I would expect more PAT use in the future and that is usually a split.

-Andi
