Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbZLPBqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbZLPBqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZLPBqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:46:33 -0500
Received: from aglcosbs02.cos.agilent.com ([192.25.218.39]:44447 "EHLO
	aglcosbs02.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756014AbZLPBqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:46:32 -0500
Message-ID: <4B283BB7.4050802@agilent.com>
Date: Tue, 15 Dec 2009 17:45:27 -0800
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-mm <linux-mm@kvack.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
References: <1228379942.5092.14.camel@twins> <4B22DD89.2020901@agilent.com> <20091214192322.GA3245@bluebox.local> <4B27905B.4080006@agilent.com> <20091215210002.GA2432@local> <4B2803D8.10704@agilent.com> <20091215222811.GC2432@local> <4B2827E8.60602@agilent.com> <20091216012347.GD2432@local>
In-Reply-To: <20091216012347.GD2432@local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2009 01:45:32.0460 (UTC) FILETIME=[7442B6C0:01CA7DF1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans J. Koch wrote:
> No, dma-mem would be a directory containing some more attributes. Maybe one
> called "create" that allocates a new buffer.
> 
[ .. snip ..]
> Writing the size to that supposed "create" attribute could allocate the
> buffer and and create more attributes that contain the information you need.

Hmm ... I can't see how to make this into a transaction.

Suppose two threads write to /sys/.../create simultaneously (or
very close together) and further suppose that each call succeeds.

It's not clear to me how each can figure out where to find the
outcome of its operation because write() doesn't return anything
other than the number of octets written.

Writing "id, size" might work, but sorting out a good enough id
might be a little clunky. A process id wouldn't be good enough (with
different threads), and a thread id might get recycled.

Any other ideas ?

Earl



