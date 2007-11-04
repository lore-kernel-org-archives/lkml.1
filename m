Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbXKDWYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbXKDWYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 17:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbXKDWY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 17:24:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50796 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbXKDWY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 17:24:26 -0500
Message-ID: <472E45BF.3070003@zytor.com>
Date: Sun, 04 Nov 2007 14:20:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
References: <200711042158.lA4Lwv9S014628@harpo.it.uu.se>
In-Reply-To: <200711042158.lA4Lwv9S014628@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> 
> Maybe not. I had a look in Intel's SDM Vol3, and the
> section "switching to protected mode" specifies that
> a move to %cr0 that sets PE should immediately be
> followed by a far jmp or call. They write that "random
> failures can occur if other instructions exist between
> [the move to %cr0] and [the far jmp/call]". The current
> version of pmjump.S does exactly that: it executes
> a bunch of moves to segment registers in that window.
> 
> (Section 9.9.1 in the Sept. 2005 revision I have in
> front of me.)
> 
> Similarly, section "serializing instructions" writes
> that a move to %cr0 that enables or disables paging
> should be followed by a jump. They write that this isn't
> required in P4 or P6 family processors, but is required
> for compatibility with other ia32 processors. Reading
> between the lines, they imply that older ia32 processors
> don't treat %cr0 writes as completely serializing.
> 
> (Section 7.4 in the Sept. 2005 revision.)
> 

The problem is that Intel has a tendency to exaggerate in their 
documentation; in particular, they tend not to remove restrictions that 
are long-since obsolete.  However, it sounds like you have actually 
found a CPU for which this restriction is motivated.

	-hpa
