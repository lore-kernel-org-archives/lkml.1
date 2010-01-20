Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517Ab0ATS4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0ATS4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 13:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925Ab0ATS4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 13:56:25 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:56311 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab0ATS4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 13:56:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AucQjoI9qOOPd7B5OWRgGwxV+mRzTOseZjtObQ9bQ6K4I2bSW+zzhnOkmSBzRaD23o
         rXaVivqoGWgm9Y0p9eR4aHjRVRQX7Tvy3UdpT/Mc6NyHWpb6ycfNQKblNFUmubyCx/q/
         yxqCzHAPetm8PWVifjrjgNkhWCerQ5CmauL1k=
Date: Wed, 20 Jan 2010 19:56:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/6] tracing: Change trace_seq to use separate buffer
Message-ID: <20100120185614.GB6194@nowhere>
References: <4B556078.7000004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B556078.7000004@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 03:34:16PM +0800, Lai Jiangshan wrote:
> @@ -526,19 +526,19 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
>  {
>  	struct ftrace_event_call *call = filp->private_data;
>  	struct ftrace_event_field *field;
> -	struct trace_seq *s;
> +	struct trace_seq seq, *s = &seq;
> +	unsigned char *buffer;
>  	int common_field_count = 5;
> -	char *buf;
>  	int r = 0;
>  
>  	if (*ppos)
>  		return 0;
>  
> -	s = kmalloc(sizeof(*s), GFP_KERNEL);
> -	if (!s)
> +	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
> +	if (!buffer)
>  		return -ENOMEM;
>  
> -	trace_seq_init(s);
> +	trace_seq_init(s, buffer, PAGE_SIZE);



May be can we use a paired trace_seq_init_page/trace_seq_free_page,
to sum up a bit the above pattern.

