Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbZE0RPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbZE0RPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760823AbZE0RPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:15:17 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:40551 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760474AbZE0RPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:15:16 -0400
Message-ID: <4A1D7512.9080604@nortel.com>
Date: Wed, 27 May 2009 11:14:58 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ulrich Drepper <drepper@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: linux missing support for _POSIX_THREAD_CPUTIME?
References: <4A1D6E71.90602@nortel.com> <alpine.LFD.2.00.0905271855290.3397@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905271855290.3397@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2009 17:15:03.0272 (UTC) FILETIME=[AC660680:01C9DEEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 27 May 2009, Chris Friesen wrote:
> 
> That's more a question for the glibc folks. CC'ed.

Actually, I'm looking at the kernel code here.  It looks like
posix_cpu_clock_get() should be able to handle a per-task cpu clock for
another thread within the same process.  However, it's only ever called
by thread_cpu_clock_get(), which hardcodes a clock_id of THREAD_CLOCK,
which corresponds to the current thread.

Similarly, invalid_clockid() will say that the clock_id is invalid if
it's positive but greater than 15.  If my math is right, this means that
any pid > 2 will result in invalid_clockid() failing.

Chris
