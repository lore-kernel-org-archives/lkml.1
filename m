Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbYLPRY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbYLPRY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYLPRYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:24:51 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:42792 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYLPRYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:24:50 -0500
X-BigFish: VPS-35(zz1432R62a3L98dR936eQ1805Mzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBZCCU-02-SLR-01
Date: Tue, 16 Dec 2008 18:23:42 +0100
From: Robert Richter <robert.richter@amd.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/9] oprofile: port to the new ring_buffer
Message-ID: <20081216172341.GK15411@erda.amd.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com> <1229013723-8191-7-git-send-email-robert.richter@amd.com> <alpine.DEB.1.10.0812111424470.24741@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812111424470.24741@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Dec 2008 17:24:25.0217 (UTC) FILETIME=[246C8710:01C95FA3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.12.08 14:48:56, Steven Rostedt wrote:
> > Since the new tracing ring buffer implementation uses spin locks to
> > protect the buffer during read/write access, it is difficult to use
> > the buffer in an NMI handler. In this case, writing to the buffer by
> > the NMI handler (x86) could occur also during critical sections when
> > reading the buffer. To avoid this, there are 2 buffers for independent
> > read and write access. Read access is in process context only, write
> > access only in the NMI handler. If the read buffer runs empty, both
> > buffers are swapped atomically. There is potentially a small window
> > during swapping where the buffers are disabled and samples could be
> > lost.
> 
> There is plans on removing the spinlock from the write side of the buffer.
> But this will take a bit of work and care. Lockless is better, but it also 
> makes for more complex code which translates to more prone to bugs code.

In the beginning, the use of separate locks for reading and writing
would be sufficient. Then, there would be only one atomic comparison
needed to check, if the write pointer meets the read pointer. This
should be not as difficult since read and write is always in different
pages (if a am not wrong) and thus only the pointer to the pages have
to be compared.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

