Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZCXW3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZCXW3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZCXW3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:29:32 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:5564 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZCXW3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:29:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JRifuUQtPRqAxfk09rrlILU2PcvpwWsdl4apn0bkK0GBuwRZHUISIhWhYumD84rM6/
         1Z8HsrN8ajcidlXQ2l6ReW5heKNE8ahCkimIVV0AUF+ZA6m+pQgwZvTfrpiDBgrQzCY0
         hzKudNd6qfWtyeVJ0MF5eSysBzxwESgZito68=
Message-ID: <49C95EAF.7030901@gmail.com>
Date: Tue, 24 Mar 2009 18:29:03 -0400
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tim Bird <tim.bird@am.sony.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere>
In-Reply-To: <20090324213618.GC5975@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Yes, ie:
>
> _Before jumping to the function entry hook, you must save
> the arguments for the traced function on the stack.
> On x86, its eax, edx and ecx.
> On arm, it will be r0-r3.
> Then you have to transmit the address of the traced function
> (it's on r14) and it's parent (must rely on fp for that).
> Then you call the entry hook and restore the old scratch/arg
> registers.
>   
Instead of just restoring the old backed-up args, lr can be fixed up
inside the entry hook to point to the return hook. So when the traced
function returns, it actually returns to the return hook (where we can
restore the original return address). This means that
-finstrument-functions is not required at all. This is analogous to how
kretprobes work. The only difference here is that instead of planting a
kprobe at the function entry and redirecting the function return to the
profiling exit routine, we can use mcount. This is slightly more
complicated to implement but can be a very efficient alternative to
kretprobes.
--
Abhishek

