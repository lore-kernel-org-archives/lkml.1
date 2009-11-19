Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbZKSPty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbZKSPty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZKSPtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:49:53 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54275 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbZKSPtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:49:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e86hIK8hZr1JpU/0YLEBJsVJVnSs6X7CRREUDN5UYgfN1WqhlPKA+L5GbpAynNNdes
         rHuJPPCPyrewcANXJdIeIvVf8TUnL40JF8GRrfd8WdqDIG5F5bpJbNP0FOzqrQ9UEomM
         h9nIYx6C5wvFSj2eQ37KY2zWw6coj5iJJ6RVM=
MIME-Version: 1.0
In-Reply-To: <4B056820.1050104@zytor.com>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <4B056820.1050104@zytor.com>
Date: Thu, 19 Nov 2009 16:49:57 +0100
Message-ID: <84fc9c000911190749y294381a2q16f4547991525cee@mail.gmail.com>
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

On Thu, Nov 19, 2009 at 4:45 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/19/2009 07:37 AM, Thomas Gleixner wrote:
>>
>> modified function start on a handful of functions only seen with gcc
>> 4.4.x on x86 32 bit:
>>
>>       push   %edi
>>       lea    0x8(%esp),%edi
>>       and    $0xfffffff0,%esp
>>       pushl  -0x4(%edi)
>>       push   %ebp
>>       mov    %esp,%ebp
>>       ...
>>       call   mcount
>>
>
> The real questions is why we're aligning the stack in the kernel.  It is
> probably not what we want -- we don't use SSE for anything but a handful
> of special cases in the kernel, and we don't want the overhead.

It's likely because you have long long vars on the stack which is
faster when they are aligned.  -mno-stackrealign may do what you
want (or may not, I have not checked).  I assume you already
use -mpreferred-stack-boundary=2.

Richard.
