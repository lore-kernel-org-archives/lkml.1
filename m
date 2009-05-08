Return-Path: <linux-kernel-owner+w=401wt.eu-S1763591AbZEHWz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763591AbZEHWz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 18:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZEHWzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 18:55:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039AbZEHWzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 18:55:16 -0400
Date: Fri, 8 May 2009 15:52:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing/events: simplify system_enable_read()
Message-Id: <20090508155207.50727920.akpm@linux-foundation.org>
In-Reply-To: <4A0399A5.2080603@cn.fujitsu.com>
References: <4A03998E.3020503@cn.fujitsu.com>
	<4A0399A5.2080603@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 May 2009 10:32:05 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> A smarter way to figure out the output of an enable file.
> 
> [ Impact: clean up ]
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_events.c |   40 ++++++----------------------------------
>  1 files changed, 6 insertions(+), 34 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 45f1099..df394bc 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -414,10 +414,11 @@ static ssize_t
>  system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
>  		   loff_t *ppos)
>  {
> +	const char set_to_char[4] = { '?', '0', '1', 'X' };

I always worry when I see this, but gcc does manage to add the missing
`static' all by itself.  For which versions of gcc that is true I don't
know.

> +	buf[0] = set_to_char[set];

Meh.  Real men do

	buf[0] = "?01X"[set];

