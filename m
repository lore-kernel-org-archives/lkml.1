Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZKSSDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZKSSDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZKSSC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:02:59 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45287 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZKSSC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:02:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lVeznAXWPVUMudHW63jBZb3KT61IAwEmIt1u/D54AV2r20UmZq1ifjoDMShy8ndWwo
         bYF4wYg9KnFxeBlFb9lOefCK68jVbJkNdstyNw6LS+31AeuuqHgOqnBiDH9WeoUptoOm
         N9UKcWJM7xrxBP9gEZbgdUez9ektfzWNOlLyU=
MIME-Version: 1.0
In-Reply-To: <1258653562.22249.682.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>
	 <1258653562.22249.682.camel@gandalf.stny.rr.com>
Date: Thu, 19 Nov 2009 19:03:04 +0100
Message-ID: <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Richard Guenther <richard.guenther@gmail.com>
To: rostedt@goodmis.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 6:59 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2009-11-19 at 09:39 -0800, Linus Torvalds wrote:
>
>> > This modification leads to a hard to solve problem in the kernel
>> > function graph tracer which assumes that the stack looks like:
>> >
>> >        return address
>> >        saved  ebp
>>
>> Umm. But it still does, doesn't it? That
>>
>>       pushl  -0x4(%edi)
>>       push   %ebp
>>
>> should do it - the "-0x4(%edi)" thing seems to be trying to reload the
>> return address. No?
>
> Yes that is what it is doing. The problem we have is that it is putting
> into the frame pointer a "copy" of the return address, and not the
> actual pointer. Which is fine for the function tracer, but breaks the
> function graph tracer (which is a much more powerful tracer).
>
> Technically, this is all that mcount must have. And yes, we are making
> an assumption that the return address in the frame pointer is the one
> that will be used to leave the function. But the reason for making this
> copy just seems to be all messed up.
>
> I don't know if the ABI says anything about the return address in the
> frame pointer must be the actual return address. But it would be nice if
> the gcc folks would let us guarantee that it is.

Note that I only can reproduce the issue with
-mincoming-stack-boundary=2, not with -mpreferred-stack-boundary=2.
And
you didn't provide us with a testcase either ... so please open
a bugzilla and attach preprocessed source of a file that
shows the problem, note the function it happens in and provide
the command-line options you used for building.

Otherwise it's going to be all speculation on our side.

Thanks,
Richard.
