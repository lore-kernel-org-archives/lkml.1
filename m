Return-Path: <linux-kernel-owner+w=401wt.eu-S1751826AbZHFHby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbZHFHby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 03:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbZHFHbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 03:31:53 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:51927 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZHFHbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:31:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Q+ShdnI1k7jUT65TN4+NokSVpIfy/HmDgE7vzd6jsnQH5Xi2tNLL2U1pcGa1RaWOsw
         jJoSnyr51geTNOTEJUlHMSZmDr1o+aWV7rXwTRyOVEtvsj5XFYNKpY5XImkweXWGW/3y
         pw82/fRKNRUWtIxCaxdQaA1VnkTJvW7I0VdIU=
MIME-Version: 1.0
In-Reply-To: <20090805123501.GF14610@erda.amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
	 <20090803112220.GA22936@elte.hu>
	 <20090803072522.1d90f15c@infradead.org>
	 <20090804201109.GA21386@elte.hu> <20090805123501.GF14610@erda.amd.com>
Date: Thu, 6 Aug 2009 10:31:52 +0300
X-Google-Sender-Auth: 93c01ef46a839ffc
Message-ID: <84144f020908060031vb48b983m6e6b1b521e01d6aa@mail.gmail.com>
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Wed, Aug 5, 2009 at 3:35 PM, Robert Richter<robert.richter@amd.com> wrote:
> The question is more if it makes sense. It's new to me dropping
> user/kernel interfaces that are in use and forcing its developers to
> rewrite their code. Oprofile is actively developed and in many
> distros. It supports architectures perfcounters doesn't. So, what do
> you want?

Maybe we can keep the ABIs in place but use a common machinery under
the hood for both perf and oprofile? That said, I do expect oprofile
ABIs to be special meaning that there's probably not a whole lot users
other than the oprofile user-space tool? So if do convert the
user-space tool to use sys_perf_counter_open() and put the in-kernel
oprofile code into deep-maintenance mode, maybe we can eventually get
rid of it?

That said, the lack of architecture support for perf is definitely a
blocker here...

On Wed, Aug 5, 2009 at 3:35 PM, Robert Richter<robert.richter@amd.com> wrote:
> And why not having more than one profiling subsystem in the kernel? I
> see also more than one type of car on the street though all of them
> have 4 wheels.

Well, so far I've only had bad experiences with duplicate
functionality in the kernel be it a core kernel subsystem like slab or
a device driver (broadcom and e100 come to mind). The problem is that
you fragment tester and developer base and end up with a different set
of bugs for each of the duplicate components causing more work than
necessary. And what eventually happens is that you have only one
component that's under active development but you can't get rid of the
less active ones because people depend on them and the active one has
corner case bugs that just don't get fixed.

                        Pekka
