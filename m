Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab0BRPIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:08:50 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37838 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082Ab0BRPIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:08:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=okmoI2vfKqFLhssyEDkmvP4fRHzVKXh02ZsHH+Yi6g92a4WgWYIJe8T10BGeILDfN2
         4FRdMlYsF1Nb/lTFXlzQTZZStzbzHDl9Y104C6GHglFOvF4SzROCRp7JXGSMC8nV7r/H
         rQbBWBQUhHiu/6mqyMtrwOo9FRjuqj4LI6tz0=
MIME-Version: 1.0
In-Reply-To: <20100218150014.GA6593@osiris.boeblingen.de.ibm.com>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com> 
	<1266491616-6270-3-git-send-regression-fweisbec@gmail.com> 
	<8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com> 
	<20100218120944.GA2406@osiris.boeblingen.de.ibm.com> <8bd0f97a1002180412x6cc4f280u5444f013c6e3b670@mail.gmail.com> 
	<20100218123453.GA5136@nowhere> <20100218132521.GB2406@osiris.boeblingen.de.ibm.com> 
	<8bd0f97a1002180601i60c5eaa4p7639091c5b617702@mail.gmail.com> 
	<20100218150014.GA6593@osiris.boeblingen.de.ibm.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 18 Feb 2010 10:08:28 -0500
Message-ID: <8bd0f97a1002180708l577decd4y8c8a7964f924b269@mail.gmail.com>
Subject: Re: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 10:00, Heiko Carstens wrote:
> On Thu, Feb 18, 2010 at 09:01:12AM -0500, Mike Frysinger wrote:
>> On Thu, Feb 18, 2010 at 08:25, Heiko Carstens wrote:
>> > --- a/arch/Kconfig
>> > +++ b/arch/Kconfig
>> > @@ -123,6 +123,10 @@ config USE_GENERIC_SMP_HELPERS
>> >
>> >  config HAVE_REGS_AND_STACK_ACCESS_API
>> >        bool
>> > +       help
>> > +         This symbol should be selected by an architecure if it supports
>> > +         the API needed to access registers and stack entries from pt_regs.
>> > +         For example the kprobes-based event tracer needs this API.
>>
>> a bit vague ... arent there headers/functions people could look at ?
>> perhaps you're talking about the regset functions (which is an API to
>> access registers in pt_regs) ?  or you're talking about asm/syscall.h
>> (which is an API to access registers in pt_regs) ?
>>
>> i'm not asking to be a pain, i'm asking because i really havent a
>> clue.  if i wanted to add support for this stuff to the Blackfin arch,
>> i wouldnt know where to start.  even after reading this help i'd fall
>> back to grepping arch/x86/ and trying to divine a starting point from
>> there.
>
> git show b1cf540f would be your friend. That's why I pointed out the
> id in the changelog.
> I have no idea what your workflow is, but doing something like
> gitk v2.6.32..v2.6.33-rc1 arch/<whatever>/
> is what I do to figure out what other archs did during the merge
> window and if there's something that needs an arch backend on s390.
> This reveals also bug fixes that need to be ported from time to time.
> That worked pretty well for me during the last few years.

most of the time though such implementations are tied to the arch, and
for people unfamiliar with the arch in question, they can have a hard
time separating the common requirements from the arch requirements.
changelog entries also really shouldnt be the norm for documentation
of APIs, especially as APIs change over time (by design -- linux has
no stable API).  so while this commit may be useful for the next
release or two, it isnt uncommon for them to be partially if not
wholly irrelevant down the line.  which is when us smaller arches get
around to implementing this cooler features.
-mike
