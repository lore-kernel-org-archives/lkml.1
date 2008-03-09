Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbYCIU2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbYCIU2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYCIU2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:28:35 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:1627 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYCIU2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:28:35 -0400
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       heukelum@fastmail.fm
Subject: Re: [PATCH] x86: Change x86 to use generic find_next_bit
References: <20080309200103.GA895@mailshack.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Mar 2008 21:28:32 +0100
In-Reply-To: <20080309200103.GA895@mailshack.com>
Message-ID: <87zlt7zlov.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2008 20:22:01.0658 (UTC) FILETIME=[3BAAE1A0:01C88223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum <heukelum@mailshack.com> writes:
> 
> If the bitmap size is not a multiple of BITS_PER_LONG, and no set 
> (cleared) bit is found, find_next_bit (find_next_zero_bit) returns a 
> value outside of the range [0,size]. The generic version always returns 
> exactly size.

With that change it is likely possible to remove the min(NR_CPUS in
lib/cpumask.c __first/__next_cpu. iirc it was just a workaround for
the x86 quirk. I suspect with such a change it would be possible to
inline those again, possibly speeding up some loops who do cpumask
walking (iirc the scheduler used to do that frequently)

-Andi

