Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbZAFWw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbZAFWw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZAFWws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:52:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbZAFWwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:52:47 -0500
Date: Tue, 6 Jan 2009 14:50:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       roel.kluin@gmail.com, pq@iki.fi, srostedt@redhat.com
Subject: Re: [PATCH 1/3] ftrace: convert unsigned index to signed
Message-Id: <20090106145007.ceb20f16.akpm@linux-foundation.org>
In-Reply-To: <20090106223405.302758015@goodmis.org>
References: <20090106223337.677427397@goodmis.org>
	<20090106223405.302758015@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2009 17:33:38 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: fix to unsigned compared to less than zero
> 
> Roel Kluin pointed out that there is a compare of an unsigned number
> to less than zero. A previous clean up had the unsigned index set
> to -1 for certain cases, but never converted it to signed.
> 
> Frederic Weisbecker noticed that another index is used to compare
> the above index to and it also needs to be converted to signed.
> 
> Reported-by: Roel Kluin <roel.kluin@gmail.com>
> Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/ftrace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 2f32969..3576707 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -289,7 +289,7 @@ static DEFINE_MUTEX(ftrace_regex_lock);
>  
>  struct ftrace_page {
>  	struct ftrace_page	*next;
> -	unsigned long		index;
> +	long			index;

Does that actually need to be a long type?

>  	struct dyn_ftrace	records[];
>  };
>  
> @@ -786,7 +786,7 @@ enum {
>  
>  struct ftrace_iterator {
>  	struct ftrace_page	*pg;
> -	unsigned		idx;
> +	int			idx;

because we have

        if (iter->idx >= iter->pg->index) {

Are 32-bit types actually more efficient than 64-bit types on any
64-bit hardware which we care about?  
