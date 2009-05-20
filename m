Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZETXFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZETXFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbZETXFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:05:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58981 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718AbZETXFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:05:02 -0400
Message-ID: <4A148C3B.5050100@zytor.com>
Date: Wed, 20 May 2009 16:03:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
References: <4A0DCC11.10307@goop.org> <m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org> <20090515202250.0f1218ef@jbarnes-g45> <m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org> <20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org> <87tz3gnq91.fsf@basil.nowhere.org> <4A143251.90208@goop.org> <20090520225235.GJ8684@one.firstfloor.org>
In-Reply-To: <20090520225235.GJ8684@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>> Is this new interface only defined for swiotlb or MMIO mappings?
>>> If yes did you check the drivers only actually set it on
>>> swiotlb or MMIO (that seems dubious to me)?
>> Really?   Do we ever set unusual memory types on normal system memory?  
> 
> There were drivers at some point that set WC MTRRs on their
> transfer rings, not mmio.
> 
> Maybe these all switched to PAT now, maybe not

Most of those that I've heard of use WB memory and CLFLUSH.

The ones I know of which marked descriptor rings WB were ones which had
descriptor rings in MMIO space (which makes sense: MMIO reads are fully
synchronizing, but writes can be posted and write combined.)

	-hpa

