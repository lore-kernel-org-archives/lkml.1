Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbYDKSqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbYDKSqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 14:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760556AbYDKSqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 14:46:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45361 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760569AbYDKSq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 14:46:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=pJ/r3Urtb+0lAqQl5Kd03nM/sMaaAga26lK8SleSAXOTSwlI/GGy4FRqqeAGZeiM0
	lIFAbiL7QeI3V24iXQUvg==
Message-ID: <6599ad830804111146k2c3db442y3708f95a3fbee83@mail.gmail.com>
Date: Fri, 11 Apr 2008 11:46:18 -0700
From: "Paul Menage" <menage@google.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: =?WINDOWS-1252?Q?Re:_2.6.25-rc8-mm2_--_kernel/sched.c:8294:_error:_?= =?WINDOWS-1252?Q?unknown_field_=91read=5Fuint=92_specified_in_initializer?=
Cc: "Miles Lane" <miles.lane@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1207932902.7157.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0804110648g3256805fob917f31eeff4f6db@mail.gmail.com>
	 <1207932902.7157.4.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 9:55 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2008-04-11 at 09:48 -0400, Miles Lane wrote:
>  > CC      kernel/sched.o
>  > kernel/sched.c:8294: error: unknown field 'read_uint' specified in initializer
>  > kernel/sched.c:8294: warning: initialization makes integer from
>  > pointer without a cast
>  > kernel/sched.c:8295: error: unknown field 'write_uint' specified in initializer
>  > kernel/sched.c:8295: warning: initialization from incompatible pointer type
>
>  someone mucked around with the cgroup api; this should fix it:
>
>  Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>  ---
>  diff --git a/kernel/sched.c b/kernel/sched.c
>  index 7119895..8b4e0b6 100644
>  --- a/kernel/sched.c
>  +++ b/kernel/sched.c
>  @@ -8291,8 +8291,8 @@ static struct cftype cpu_files[] = {
>         },
>         {
>                 .name = "rt_period_us",
>  -               .read_uint = cpu_rt_period_read_uint,
>  -               .write_uint = cpu_rt_period_write_uint,
>  +               .read_u64 = cpu_rt_period_read_uint,
>  +               .write_u64 = cpu_rt_period_write_uint,
>         },
>   #endif
>

Sorry - this change was in my original API patch (plus renaming the
read/write functions to have u64 suffices) but I think it collided
with the git-sched instability around the end of February.

Paul
