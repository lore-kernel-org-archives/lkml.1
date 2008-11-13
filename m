Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbYKMRt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbYKMRt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYKMRqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:46:16 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:14643 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYKMRqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:46:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ogfGDnuYlQCD+r1mc+5BRwt7E7dcQQSBI7R5hV5wBr094ktuitX4RVfHwOFLofNnwB
         kJHR78SuK1qHyuMPkUno7AS1dXPxUq9lwa+rsfME3XFhK5N5812P1jC6qVM0lUaZPk5v
         s3Cpir5U4YS7KOiTf2sq0AJ2Qv/eATLy5+Iqw=
Message-ID: <c62985530811130946g3dad0wf161d08f8ffb4db1@mail.gmail.com>
Date: Thu, 13 Nov 2008 18:46:12 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function return tracer lockless
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811131230470.23751@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491B4F0A.3080901@gmail.com> <87od0jd6ds.fsf@basil.nowhere.org>
	 <c62985530811130901t7ddf84beof39a964582fb94a0@mail.gmail.com>
	 <20081113171220.GX3810@one.firstfloor.org>
	 <alpine.DEB.1.10.0811131219250.23751@gandalf.stny.rr.com>
	 <20081113173451.GY3810@one.firstfloor.org>
	 <alpine.DEB.1.10.0811131230470.23751@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/13 Steven Rostedt <rostedt@goodmis.org>:
>
> On Thu, 13 Nov 2008, Andi Kleen wrote:
>
>> > So the answer to this is:
>> >
>> >   i = index++;
>> >   barrier();
>> >   write to index i (not index);
>>
>> That was my first thought when I wrote the original email,
>> but the disadvantage is that barrier() is a big hammer
>> that flushes everything and can make the code much worse.
>> That is why I suggested local_add_return() instead.
>
> barrier() is a compiler barrier, does nothing with the caches, and is
> quite cheap. We only need a compiler barrier because we are only
> protecting ourselves from things that happen on the current CPU. No other
> devices or other CPUs are involved.


Oh I see the issue now. The value of the index could have been
incremented in a register and not yet
in the memory...
So yes, a barrier() to make these operations flushed in memory before
using the index.
