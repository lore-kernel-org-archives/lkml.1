Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYDJIra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYDJIra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYDJIrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:47:22 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:36981 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbYDJIrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:47:21 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org, apw@shadowen.org
Subject: Re: [PATCH] pop previous section in alternative.c
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com>
	<Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com>
	<47FD5D42.5000603@zytor.com>
Date: Thu, 10 Apr 2008 10:47:18 +0200
In-Reply-To: <47FD5D42.5000603@zytor.com> (H. Peter Anvin's message of "Wed, 09 Apr 2008 17:20:18 -0700")
Message-ID: <87wsn6m6zt.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Apr 2008 08:40:34.0467 (UTC) FILETIME=[8AF72F30:01C89AE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>>>
>> Oh, and this would not be complete without giving Andrew Pinski
>> complete
>> credit for telling me it wasn't a gcc bug but a bug in the toplevel asm
>> code in the kernel. ;-)

We've actually had such bugs before, it isn't the first time.

>
> In many ways it's kind of silly for this even to be in assembly, since
> all it is is a sequence of comma-separated byte values; I guess it was
> the easiest way to deal with it given the ".byte" prefix, but still...

The nops are primarily used in inline assembler statements (in alternative)
and only once in this table. Not using this would have meant to write
them all twice which would have been nasty. There is also no sane 
way to get standard arrays into inline assembler as instructions.

BTW it looks like the problem was added with 121d7bf5a246d282ba91234d03a4edf9ccc9c940,
signed off by me, sorry for not catching it in review.

Perhaps that is something that would make sense adding to checkpatch.pl?
Complain for .section in inline assembler without .previous or popsection
(cc Andy). I think such a check would make sense. 

-Andi
