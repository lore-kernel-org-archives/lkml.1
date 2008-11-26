Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYKZLTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYKZLTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYKZLTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:19:09 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:57509 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYKZLTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:19:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Y5+98IEu8+AAVY7J5vA01QndkEbC8GsB5Sc1My77RSzUGdK3g9U2fwjy9k5Umhi9kM
         EtuHdxddJAXN6aax8DGxT6lI3tZDJU+IsitAcxg/O8G8RFCt8xmwarvVZDnYQ+vnM9zI
         Lx7QYeBhdp7Cj0PdScY1IeHsY1xAi6LpVA4Vo=
Message-ID: <c62985530811260319vd5fcfcdtc0140fba8bd7e8b9@mail.gmail.com>
Date: Wed, 26 Nov 2008 12:19:04 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-return-tracer: set a more human readable output
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081126021450.GA17617@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492C90E5.8070907@gmail.com> <20081126003936.GA26937@elte.hu>
	 <20081126021450.GA17617@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/26 Ingo Molnar <mingo@elte.hu>:
>
> the regex filter doesnt work well yet when used with the graph tracer:
>
> [ 2994.079079] ------------[ cut here ]------------
> [ 2994.079079] WARNING: at kernel/trace/ftrace.c:373 ftrace_bug+0x8c/0x1ce()
> [ 2994.079079] Modules linked in:
> [ 2994.079079] Pid: 12, comm: kstop/0 Not tainted 2.6.28-rc6-tip #2056
> [ 2994.079079] Call Trace:
> [ 2994.079079]  [<c02273dd>] warn_on_slowpath+0x46/0x60
> [ 2994.079079]  [<c0268308>] ? trace_graph_return+0x89/0xa7
> [ 2994.079079]  [<c0268308>] ? trace_graph_return+0x89/0xa7
> [ 2994.079079]  [<c0213e85>] ? ftrace_return_to_handler+0x6b/0x74
> [ 2994.079079]  [<c0357f66>] ? memcpy+0xe/0x31
> [ 2994.079079]  [<c02633e6>] ? rb_commit+0x29/0x2d
> [ 2994.079079]  [<c0264c8b>] ? ring_buffer_unlock_commit+0x15/0x1a
> [ 2994.079079]  [<c0213ece>] ? ftrace_modify_code+0x21/0xa3
> [ 2994.079079]  [<c0213e85>] ? ftrace_return_to_handler+0x6b/0x74
> [ 2994.079079]  [<c026c3ce>] ? probe_kernel_read+0xe/0x5c
> [ 2994.079079]  [<c0261ec7>] ? trace_selftest_dynamic_test_func+0x3/0xc
> [ 2994.079079]  [<c0203926>] ? return_to_handler+0xa/0x14
> [ 2994.079079]  [<c0261ec7>] ? trace_selftest_dynamic_test_func+0x3/0xc
> [ 2994.079079]  [<c0213ee5>] ? ftrace_modify_code+0x38/0xa3
> [ 2994.079079]  [<c0261ec7>] ? trace_selftest_dynamic_test_func+0x3/0xc
> [ 2994.079079]  [<c0262749>] ftrace_bug+0x8c/0x1ce
> [ 2994.079079]  [<c026299c>] ftrace_replace_code+0x111/0x13d
> [ 2994.079079]  [<c0253b53>] ? stop_cpu+0x0/0xa5
> [ 2994.079079]  [<c02629e6>] __ftrace_modify_code+0x1e/0x32
> [ 2994.079079]  [<c0253bbe>] stop_cpu+0x6b/0xa5
> [ 2994.079079]  [<c020391c>] return_to_handler+0x0/0x14
> [ 2994.079079]  [<c020391c>] return_to_handler+0x0/0x14
> [ 2994.079079]  [<c0237fc1>] ? autoremove_wake_function+0x0/0x35
> [ 2994.079079]  [<c023584b>] ? worker_thread+0x0/0xc7
> [ 2994.079079]  [<c0237eba>] kthread+0x40/0x66
> [ 2994.079079]  [<c0237e7a>] ? kthread+0x0/0x66
> [ 2994.079079]  [<c02038cb>] kernel_thread_helper+0x7/0x10
> [ 2994.079079] ---[ end trace bff97d149b80ecde ]---
> [ 2994.079079] ftrace failed to modify [<c0261ec7>] trace_selftest_dynamic_test_func+0x3/0xc
> [ 2994.079079]  actual: e8:0c:1a:fa:ff
>
> produced via:
>
>  # cd /debug/tracing/
>  # cat set_ftrace_filter
>  # echo schedule > set_ftrace_filter
>  # cat set_ftrace_filter
>  cat: set_ftrace_filter: No such device


I didn't met this problem by the past with dynamic filtering on return
tracer. Did it occur only with schedule ?
Do the last patches from Steve correct the issue?
