Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYK1JOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYK1JOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYK1JOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:14:07 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:34796 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYK1JOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:14:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=g5Y/r80ifYn8UyG6WLGfJXDqqWxlRdWkDgc3V4htW8+vtfIUzHVPRRQnVM2eCwqnhN
         hofxQ0B5qSK0udKx+si/vpLhKyrInC4PP0AL71kkCyrptv9bbhp3YWizWuTWLpbeU9Xr
         sVuA9pscxG2HuENuQg8fInWDaO47svzozJWqg=
Message-ID: <c62985530811280114s50abe288q255a185b6d64c81b@mail.gmail.com>
Date: Fri, 28 Nov 2008 10:14:03 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: next-2008-11-27: tracing on alpha (again)
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org, mingo@elte.hu,
       edwintorok@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081128090258.GA27346@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081128090258.GA27346@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/28 Alexey Dobriyan <adobriyan@gmail.com>:
> On alpha-smp-n-debug-y:
>
>  CC      kernel/trace/trace.o
> kernel/trace/trace.c: In function 'ftrace_trace_userstack':
> kernel/trace/trace.c:968: error: storage size of 'trace' isn't known
> kernel/trace/trace.c:968: warning: unused variable 'trace'
> make[3]: *** [kernel/trace/trace.o] Error 1


I think it needs a missing #ifdef CONFIG_STACKTRACE inside
ftrace_trace_userstack.

>  CC      kernel/trace/trace_branch.o
> kernel/trace/trace_branch.c: In function 'probe_likely_condition':
> kernel/trace/trace_branch.c:44: error: implicit declaration of function 'raw_local_irq_save'
> kernel/trace/trace_branch.c:76: error: implicit declaration of function 'raw_local_irq_restore'
>

Needs a missing #include <linux/irqflags.h>

I don't have time to submit patches now. Probably this night....
