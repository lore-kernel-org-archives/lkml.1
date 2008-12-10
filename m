Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYLJBxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYLJBxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 20:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYLJBxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 20:53:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32935 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYLJBxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 20:53:11 -0500
Message-ID: <493F2009.6060300@zytor.com>
Date: Tue, 09 Dec 2008 17:48:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Zachary Amsden <zach@vmware.com>, Huang Ying <ying.huang@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, norman@thebacks.co.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alok Kataria <alokkataria1@gmail.com>,
       =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <"bruno .premont"@restena.lu>,
       xl@xlsigned.net, dsd@gentoo.org
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27+ kernels
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com> <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com>
In-Reply-To: <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> VMI initialiation can relocate the fixmap, causing early_ioremap
> to malfunction if it is initialized before the relocation.  The
> ioremap area is low enough in virtual address space that no actual
> collision occurs, however, because the pagetables for it were not
> allocated under VMI mode, the pagetable updates are dropped by
> the hypervisor as irrelevant, resulting in a crash on boot.
> 

I have mentioned in the past that I think the very concept of relocating
the fixmap to be utterly braindead.  Instead, I believe we should locate
it low in kernel space so it doesn't have to be relocated.  It's
unfortunately a relatively large change.

	-hpa
