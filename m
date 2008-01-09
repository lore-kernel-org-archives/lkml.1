Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYAIXOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYAIXOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYAIXOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:14:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750AbYAIXO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:14:29 -0500
Date: Wed, 9 Jan 2008 15:13:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: ricknu-0@student.ltu.se, nadia.derbey@bull.net,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm] new warning in ipc/msg.c
Message-Id: <20080109151319.edff136c.akpm@linux-foundation.org>
In-Reply-To: <4784EB6A.5020604@bull.net>
References: <4784EB6A.5020604@bull.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jan 2008 16:42:34 +0100
Pierre Peiffer <pierre.peiffer@bull.net> wrote:

> Hi,
> 
> This very small patch:
>     ipc-convert-handmade-min-to-min.patch
> introduces a new warning when compiling the -mm kernel:
> 
> .../linux-2.6.24-rc6-mm1/ipc/msg.c: In function `do_msgrcv':
> .../linux-2.6.24-rc6-mm1/ipc/msg.c:939: warning: comparison of distinct pointer
> types lacks a cast
> 
> I don't know if doing in include/linux/msg.h
> 
> struct msg_msg {
> 	struct list_head m_list;
> 	long  m_type;
> -	int m_ts;           /* message text size */
> +	size_t m_ts;           /* message text size */
> 	struct msg_msgseg* next;
> 	void *security;
> 	/* the actual message follows immediately */
> };
> 
> is acceptable ?
> 
> Otherwise, either a cast can be added or this patch can be dropped...
> 

Thanks.  I think I'll drop the original patch.  The mix of ints, size_t's,
etc in that code is pretty random and would be best addressed by somene
sitting down and working out from scratch what types we _should_ be using
in there and then making all the code use the right types in an organised
fashion.

Doing this in a piecemeal through-a-pinhole fashion won't work very well
and is a bit risky.

