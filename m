Return-Path: <linux-kernel-owner+w=401wt.eu-S1751130AbXDUSJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbXDUSJW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 14:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbXDUSJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 14:09:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:35253 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbXDUSJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 14:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LMaC0at3S1GfpqfSDkzCFnVzHG4ze3uVN66WJd9wxg6Yds6aU8EkjCWyhK5aij5qJMeCoCgikMNpYGjpEJJ2VxLLFRQW7a8nZS/VNgPwPDn54Rmsf1lbxsppksciO5qKLeo53C2pnbq5i3JYwqeI415HaxhMJpecQVmck7ZyFYg=
Message-ID: <a36005b50704211109s7a0f19a4k868ed05f2423c365@mail.gmail.com>
Date: Sat, 21 Apr 2007 11:09:20 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Willy Tarreau" <w@1wt.eu>, "Con Kolivas" <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Gene Heskett" <gene.heskett@gmail.com>
In-Reply-To: <20070421165347.GA26903@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu>
	 <20070421154614.GA26169@elte.hu> <20070421161818.GC7840@1wt.eu>
	 <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org>
	 <20070421165347.GA26903@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/07, Ingo Molnar <mingo@elte.hu> wrote:
> on a simple 'ls' command:
>
>   21310 clone(child_stack=0,  ...) = 21399
>   ...
>   21399 execve("/bin/ls",
>   ...
>   21310 waitpid(-1, <unfinished ...>
>
> the PID is -1 so we dont actually know which task we are waiting for.

That's a special case.  Most programs don't do this.  In fact, in
multi-threaded code you better never do it since such an unqualified
wait might catch the child another thread waits for (particularly bad
if one thread uses system()).

And even in the case of bash, we probably can change to code to use a
qualified wait in case there are no other children.  This is known at
any time and I expect that most of the time there are no background
processes.  At least in shell scripts.
