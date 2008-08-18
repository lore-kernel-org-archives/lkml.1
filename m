Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYHRWO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYHRWO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYHRWOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:14:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39703 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYHRWOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:14:46 -0400
Message-ID: <48A9F36B.8090509@zytor.com>
Date: Mon, 18 Aug 2008 15:10:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: David Fries <david@fries.net>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
References: <20080818040340.GB17528@spacedout.fries.net> <Pine.LNX.4.55.0808180510480.26857@cliff.in.clinika.pl> <20080818125803.GC17528@spacedout.fries.net> <20080818220419.GB2053@elf.ucw.cz>
In-Reply-To: <20080818220419.GB2053@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> Okay, can it happen that that cr4 is zero legitimately? If newer 486SX
> chips support cr4 but not coprocessor...?
> 									Pavel

Theoretically it can, but that means no features are enabled, so there 
is no need to enable the features.

The real question is if the following can happen: can it be such that we 
want CR4 to be zero in a situation where CR4 is nonzero to start out with?

The main bit in CR4 that could be set that we wouldn't want set would be 
CR4.PAE, so this could happen if there is a CPU with CR4.PAE but none of 
the other CR4 bits that we would normally set unconditionally.

I'm pretty sure this can't happen on any physical CPUs, since all 
physical CPUs supporting PAE would also support DE, MCE, and PGE.  It 
could possibly happen on a virtual CPU, although it is of course 
extremely unlikely we'd get there with CR4 not zero to start out with.

Still, it is at least theoretically wrong.

	-hpa
