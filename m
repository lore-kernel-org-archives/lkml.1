Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbZKHThv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbZKHThv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 14:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZKHThu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 14:37:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53344 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbZKHThu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 14:37:50 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] RFC x86_64 more accurate KSTK_ESP implementation
From: Andi Kleen <andi@firstfloor.org>
References: <1257233486.22553.6.camel@wall-e> <20091103082843.GA27676@elte.hu>
	<1257239184.4889.15.camel@wall-e> <1257409189.26874.18.camel@wall-e>
	<20091108113546.GN11372@elte.hu>
Date: Sun, 08 Nov 2009 20:37:50 +0100
In-Reply-To: <20091108113546.GN11372@elte.hu> (Ingo Molnar's message of "Sun, 8 Nov 2009 12:35:46 +0100")
Message-ID: <87639k7qpd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> I'd suggest a competely different method: why dont you use an IPI to 
> sample the SP whenever someone wants to read it from /proc and we see 
> that the task is running on a CPU right now?

Most of /proc tends to turn into a fast path when you run the right
monitoring tools unfortunately, which poll /proc at sometimes
quite high frequencies.

I suspect you'll slow something down significantly with this approach.

The only good way to avoid that would be to use a separate file, but again
if someone really wants it they can as well just use a ptrace()
based program from user space.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
