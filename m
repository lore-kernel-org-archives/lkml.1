Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab0BCThO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:37:14 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:46495 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab0BCThI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:37:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wBWqxp6Yh0hUZbDM4L2TwUxOLQPYmxZrMllnYXVE6jJ1nLQO5oOJ947oL2T0hLQgbG
         nqTzAzscsV0lUvQXXdJ2sAHxXAR0Auw2/w5DQkVy10WHS+syn80JC4DIhtB0cICRDUWY
         gidDVUmAwQv+2KYbu7rgBfJNeR+pSOj5EsSeU=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a1002021229x1c84d13flcc95102b7723468c@mail.gmail.com>
References: <20100202185755.GA3630@lst.de> <20100202185907.GE3630@lst.de> 
	<8bd0f97a1002021229x1c84d13flcc95102b7723468c@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 3 Feb 2010 14:36:47 -0500
Message-ID: <8bd0f97a1002031136h2573b05cr8dada3bd78ffaa38@mail.gmail.com>
Subject: Re: [PATCH 5/14] blackfin: use generic ptrace_resume code
To: Christoph Hellwig <hch@lst.de>
Cc: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 15:29, Mike Frysinger wrote:
> On Tue, Feb 2, 2010 at 13:59, Christoph Hellwig wrote:
>> Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT,
>> PTRACE_KILL and PTRACE_SINGLESTEP.  This implies defining
>> arch_has_single_step in <asm/ptrace.h> and implementing the
>> user_enable_single_step and user_disable_single_step functions, which
>> also causes the breakpoint information to be cleared on fork, which
>> could be considered a bug fix.
>>
>> Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL
>> which it previously wasn't which is consistent with all architectures
>> using the modern ptrace code.
>
> i have local code in the Blackfin tree that does part of this patch
> (and has been tested), so i'll split this patch apart and merge into
> my tree.  thanks!

i added tracehook support to Blackfin recently, so that covered all
the new functions here.  i just had to drop the handling of the
PTRACE_xxx things that common code already does.

when did you want to push through these updates ?  i was planning on
sending these ptrace() updates through the Blackfin tree as part of my
2.6.34 queue.  i'm guessing you didnt want this stuff in 2.6.33 ...
-mike
