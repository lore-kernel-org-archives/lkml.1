Return-Path: <linux-kernel-owner+w=401wt.eu-S1764107AbYDOCj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764107AbYDOCj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 22:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759827AbYDOCjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 22:39:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759221AbYDOCjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 22:39:19 -0400
Date: Mon, 14 Apr 2008 19:38:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Paul Menage" <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.25-rc8-mm2 -- kernel/sched.c:8294: error: unknown field
 =?UTF-8?Q?=E2=80=98read=5Fuint=E2=80=99?= specified in initializer
Message-Id: <20080414193855.74ea0d88.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0804141928p2fbf4006j5d365918e3b8073e@mail.gmail.com>
References: <a44ae5cd0804110648g3256805fob917f31eeff4f6db@mail.gmail.com>
	<1207932902.7157.4.camel@twins>
	<6599ad830804111146k2c3db442y3708f95a3fbee83@mail.gmail.com>
	<1207940124.7427.1.camel@twins>
	<a44ae5cd0804141928p2fbf4006j5d365918e3b8073e@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 22:28:27 -0400 "Miles Lane" <miles.lane@gmail.com> wrote:

> Hmm.  This is showing up in 2.6.25-rc9 and looks related to the
> problem in 2.6.25-rc9-mm2:
> 
>   CC      kernel/sched.o
> kernel/sched.c:7988: error: unknown field 'read_u64' specified in initializer
> kernel/sched.c:7988: error: 'cpu_shares_read_u64' undeclared here (not
> in a function)
> kernel/sched.c:7989: error: unknown field 'write_u64' specified in initializer
> kernel/sched.c:7989: error: 'cpu_shares_write_u64' undeclared here
> (not in a function)
> kernel/sched.c:7995: error: unknown field 'read_s64' specified in initializer
> kernel/sched.c:7995: warning: initialization makes integer from
> pointer without a cast
> kernel/sched.c:7996: error: unknown field 'write_s64' specified in initializer
> kernel/sched.c:7996: warning: initialization from incompatible pointer type
> kernel/sched.c:8000: error: 'cpu_rt_period_read_uint' undeclared here
> (not in a function)
> kernel/sched.c:8001: error: 'cpu_rt_period_write_uint' undeclared here
> (not in a function)

I'm suspecting that you applied the -mm patch, then you applied
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix.patch,
then you reverted the -mm patch but didn't revert
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix.patch.
