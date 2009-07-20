Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZGTVWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZGTVWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZGTVWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:22:03 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:53233 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZGTVWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:22:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q0MatHz1Xlf0jOcoz4/1/7GShRHW4htCnAFF3E3f8iQGSObRfeyyJC2g4gX3OlG986
         xb9hDSe6ahsFl8HIVtvjhqJRZmXWui+rpRe2q7CoQcxmo49RY08I27zeu9fKdhfFv6xx
         KKYqZ4PNeW8Kp+Hh/b+l/8WuKJzmqKTopgzvU=
MIME-Version: 1.0
In-Reply-To: <1248111537.15751.9341.camel@twins>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
	 <1248109687-7808-6-git-send-email-fweisbec@gmail.com>
	 <1248111537.15751.9341.camel@twins>
Date: Mon, 20 Jul 2009 17:22:00 -0400
Message-ID: <c62985530907201422i3f18813at7f6028e4be68d48f@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware 
	breakpoints
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/20, Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Mon, 2009-07-20 at 13:08 -0400, Frederic Weisbecker wrote:
>> This adds the support for kernel hardware breakpoints in perfcounter.
>> It is added as a new type of software counter and can be defined by
>> using the counter number 5 and by passsing the address of the
>> breakpoint to set through the config attribute.
>
> This seems to be IP based breakpoints. Are there plans for data based
> breakpoints as well? In that case we might want to think about the
> namespace issue, we cannot both call them breakpoint/bp etc.. ;-)


Nop, by default these breakpoints trigger on READ/WRITE accesses, it's
meant for data.
The example in the changelog profiles the bkl accesses, not by tracing
lock_kernel() or so...but by tracing the kernel_flag spinlock itself.

So it's the opposite, we may start thinking about naming issues
against possible future plans
for IP breakpoint :-)

But actually for the latter case, I would suggest Kprobe...

Damn, I forgot Masami in the Cc list...
