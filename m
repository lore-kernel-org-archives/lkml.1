Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbZKSPwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbZKSPwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbZKSPwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:52:20 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:34791 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575AbZKSPwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:52:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Eqv1WYE5A6dPhCsOcprZQ33TiekZO4gGvcQOS497bkl27xVOM+o3ZClg7HAHI7DnAY
         XQYMok9GG07D/29g1bahgDb5b6GEfWtUjrIb/C6pLGV+vgGJjf9GEM45KtFuB0RaCzJ+
         dyEJhrU4Upg6W3ILGL1rMNMQWNPAFC8kT3fEA=
MIME-Version: 1.0
In-Reply-To: <84fc9c000911190749y294381a2q16f4547991525cee@mail.gmail.com>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <4B056820.1050104@zytor.com>
	 <84fc9c000911190749y294381a2q16f4547991525cee@mail.gmail.com>
Date: Thu, 19 Nov 2009 16:52:24 +0100
Message-ID: <84fc9c000911190752o27afbc31o8a6196ebdfc68d39@mail.gmail.com>
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Richard Guenther <richard.guenther@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 4:49 PM, Richard Guenther
<richard.guenther@gmail.com> wrote:
> On Thu, Nov 19, 2009 at 4:45 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 11/19/2009 07:37 AM, Thomas Gleixner wrote:
>>>
>>> modified function start on a handful of functions only seen with gcc
>>> 4.4.x on x86 32 bit:
>>>
>>>       push   %edi
>>>       lea    0x8(%esp),%edi
>>>       and    $0xfffffff0,%esp
>>>       pushl  -0x4(%edi)
>>>       push   %ebp
>>>       mov    %esp,%ebp
>>>       ...
>>>       call   mcount
>>>
>>
>> The real questions is why we're aligning the stack in the kernel.  It is
>> probably not what we want -- we don't use SSE for anything but a handful
>> of special cases in the kernel, and we don't want the overhead.
>
> It's likely because you have long long vars on the stack which is
> faster when they are aligned.  -mno-stackrealign may do what you
> want (or may not, I have not checked).  I assume you already
> use -mpreferred-stack-boundary=2.

Just checking it seems you must be using -mincoming-stack-boundary=2
instead but keep the preferred stack boundary at 4.

Richard.
