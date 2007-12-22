Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbXLVKbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbXLVKbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 05:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXLVKbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 05:31:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45735 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbXLVKbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 05:31:43 -0500
Date: Sat, 22 Dec 2007 02:31:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] msg.h: Convert m_ts from int to size_t.
Message-Id: <20071222023137.c8800f6f.akpm@linux-foundation.org>
In-Reply-To: <20071217023600.24944.84644.sendpatchset@thinktank.campus.ltu.se>
References: <20071217023555.24944.62155.sendpatchset@thinktank.campus.ltu.se>
	<20071217023600.24944.84644.sendpatchset@thinktank.campus.ltu.se>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 03:36:00 +0100 (MET) Richard Knutsson <ricknu-0@student.ltu.se> wrote:

> Convert m_ts ("message text size") from int to size_t.
> 
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Remove some trailing spaces, since we are in the neighborhood.
> 
> 
> diff --git a/include/linux/msg.h b/include/linux/msg.h
> index 10a3d5a..7a61952 100644
> --- a/include/linux/msg.h
> +++ b/include/linux/msg.h
> @@ -67,8 +67,8 @@ struct msginfo {
>  /* one msg_msg structure for each message */
>  struct msg_msg {
>  	struct list_head m_list; 
> -	long  m_type;          
> -	int m_ts;           /* message text size */
> +	long  m_type;
> +	size_t m_ts;           /* message text size */
>  	struct msg_msgseg* next;
>  	void *security;
>  	/* the actual message follows immediately */

hm, spose so.  But if we're to do this then we'd need to fix qsize and
r_maxsize and various other things.  And we'd need to convert msg_bytes to
atomic_size_t, which would prove interesting ;)

So this is at best a partial conversion and the code in there does need
careful checking for the use of appropriate types.  Does this patch get us
partway toward the proper solution?  Dunno - someone would need to sit down
and work out what the best types are for all those related things.


