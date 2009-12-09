Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbZLIFv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbZLIFv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZLIFv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:51:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50366 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZLIFvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:51:55 -0500
X-Authority-Analysis: v=1.0 c=1 a=EJ3mDL9EkcAA:10 a=7U3hwN5JcxgA:10 a=KV5Y6eEFBC5jRWrvKVEA:9 a=a8aXp20dvJW_DNFF_w6w17WBmdsA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 05/13] ftrace: Call trace_parser_clear() properly
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B1DC4D2.3000406@cn.fujitsu.com>
References: <4B1DC476.3030700@cn.fujitsu.com>
	 <4B1DC4D2.3000406@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 09 Dec 2009 00:52:00 -0500
Message-ID: <1260337920.2146.66.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 11:15 +0800, Li Zefan wrote:
> I found a weird behavior:
> 
>   # echo 'fuse:*' > set_ftrace_filter
>   bash: echo: write error: Invalid argument
>   # cat set_ftrace_filter
>   fuse_dev_fasync
>   fuse_dev_poll
>   fuse_copy_do
> 
> We should call trace_parser_clear() no matter ftrace_process_regex()
> returns 0 or -errno.

This confused me at first. I applied this patch and I saw that I still
got the warning, but the functions did not got through. Then I realized
that there was no ":mod:" in that filtering.

Yeah, that was a weird side effect. Good catch!

-- Steve


