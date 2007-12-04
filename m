Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbXLDVRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbXLDVRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbXLDVKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:10:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33831 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755563AbXLDVKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:10:37 -0500
Date: Tue, 4 Dec 2007 13:09:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       David Holmes - Sun Microsystems <David.Holmes@Sun.COM>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix for futex_wait signal stack corruption
In-Reply-To: <1196801858.1645.37.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.9999.0712041307270.32379@woody.linux-foundation.org>
References: <1196801858.1645.37.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Dec 2007, Steven Rostedt wrote:
>
> The solution I did to solve this is to allocate a temporary buffer when
> setting up the block and free it in futex_wait_restart. This patch
> allows David's test program to actually pass.

No. Unacceptable. This is a memory leak in case nobody retries it. It's 
basically not how you can do this thing.

The *only* thing you can pass for a system call restart is the argument 
block register state. If that is not enough, then you cannot restart it. 
It's that simple.

Andrew, please do *not* put this in any queues. It's fundamentally broken, 
and cannot be fixed as is. 

		Linus
