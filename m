Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYKFGRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYKFGRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbYKFGRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:17:09 -0500
Received: from smtp-out.google.com ([216.239.33.17]:30740 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbYKFGRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:17:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=LZDpyVr5j2wiluT3iJrwKh4vzYMjHjUBGwMsADOm+UQWV8IsUEU+1N+HVnOa6qwvX
	YS3PjRIV/DW6a33g9/2JQ==
MIME-Version: 1.0
In-Reply-To: <20081106061125.GA6384@elte.hu>
References: <b040c32a0811052158r4f6662dega3503a0c7ec72620@mail.gmail.com>
	 <20081106061125.GA6384@elte.hu>
Date: Wed, 5 Nov 2008 22:16:59 -0800
Message-ID: <b040c32a0811052216i4594a094gdcee3ae280cddec7@mail.gmail.com>
Subject: Re: [patch] sched: fix single-depth wchan output
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 10:11 PM, Ingo Molnar <mingo@elte.hu> wrote:
> hm, this adds overhead - and the thing is that WCHAN is rather
> uninformative to begin with (because it's a single dimension), so we
> should phase it out, not expand it.
>
> How about adding a /proc/<PID>/stacktrace file that gives us the stack
> trace of any task in the system? That would be useful for a number of
> other purposes as well, and about 100 times more useful than wchan.
> (often it would be more useful than sysrq-t dumps)

Sure, my main motivation is to remove frame pointer generation. x86_64
unconditionally adds fp for kernel/sched.c right now.  I'm all for
phasing out wchan if people don't think there is value in it.

- Ken
