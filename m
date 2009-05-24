Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbZEXUb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbZEXUb5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 16:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZEXUbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 16:31:50 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:50074 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZEXUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 16:31:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YWyrac0OZYp8TyssZSA+hbO8K5hX+Wt+F1ldvikQbdCyVTx8nyYxHsYjFm6SX7QEXI
         NoRfJOlfIGgBxmt7TzmQ5rFCxGmYykJA6USmHq/yVOwpURP2lZ42UiSkqU+OFvjAb1us
         n8ex2sszuT/9nCzByIa+HeHIHhg+nib1luG8c=
Date: Sun, 24 May 2009 22:31:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/events: change the type of __str_loc_item to
	unsigned short
Message-ID: <20090524203148.GA6471@nowhere>
References: <4A14EDB6.2050507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A14EDB6.2050507@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 01:59:18PM +0800, Li Zefan wrote:
> When defining a dynamic size string, we add __str_loc_##item to the
> trace entry, and it stores the location of the actual string in
> entry->_str_data[]
> 
> 'unsigned short' should be sufficient to store this information, thus
> we save 2 bytes per dyn-size string in the ring buffer.
> 
> [ Impact: reduce memory occupied by dyn-size strings in ring buffer ]
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/trace/ftrace.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index edb02bc..b5ff2e8 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -25,7 +25,7 @@
>  #define __field(type, item)		type	item;
>  
>  #undef __string
> -#define __string(item, src)		int	__str_loc_##item;
> +#define __string(item, src)		unsigned short	__str_loc_##item;
>  
>  #undef TP_STRUCT__entry
>  #define TP_STRUCT__entry(args...) args
> -- 1.5.4.rc3 


Yeah, a max length of about 32000 is sufficient, the filter
engine is bounded to MAX_FILTER_STR_VAL anyway :)

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

