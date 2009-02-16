Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZBPUQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZBPUQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZBPUQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:16:28 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:30183 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZBPUQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:16:28 -0500
MIME-Version: 1.0
In-Reply-To: <20090216103636.GC17355@linux.vnet.ibm.com>
References: <4997672B.1000301@fatooh.org> <1234697096.4713.24.camel@laptop>
	 <20090216103636.GC17355@linux.vnet.ibm.com>
Date: Mon, 16 Feb 2009 15:16:25 -0500
Message-ID: <f73f7ab80902161216j8690f05sf1103759cc932846@mail.gmail.com>
Subject: Re: RT scheduling and a way to make a process hang, unkillable
From: Kyle Moffett <kyle@moffetthome.net>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Corey Hickey <bugfood-ml@fatooh.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 5:36 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> On Sun, Feb 15, 2009 at 12:24:56PM +0100, Peter Zijlstra wrote:
>> On Sat, 2009-02-14 at 16:51 -0800, Corey Hickey wrote:
>> > The procedure is for a program to:
>> > 1. run as root
>> > 2. set SCHED_FIFO
>> > 3. change UID to a user with no realtime CPU share allocated
>>
>> Hmm, setuid() should fail in that situation.
>>
>> /me goes peek at code.
>>
>> Can't find any code to make that happen, Dhaval didn't we fix that at
>> one point?
>
> So after some searching around, I realized we did not. Does this help?
> It fixes it on my system,
>
> --
> sched: Don't allow setuid to succeed if the user does not have rt bandwidth

Erm, hrm, this reminds me of the old sendmail capabilities bug.  There
are an awful lot of buggy binaries out there who assume that if they
have uid 0 and they call setuid() that it cannot fail.  They then do
all sorts of insecure operations, assuming that they have dropped to
an unprivileged UID.  This one is especially bad because it could bite
*any* program using setuid() which an admin happens to run with chrt.

Specifically, I personally think that:
  *  Process is stuck and unkillable

is a much better result than:
  *  Process runs arbitrary untrusted code with full-root privs in RT mode.

Cheers,
Kyle Moffett
