Return-Path: <linux-kernel-owner+w=401wt.eu-S1761100AbZENXSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100AbZENXSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761460AbZENXSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 19:18:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760878AbZENXSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 19:18:35 -0400
Date: Thu, 14 May 2009 16:17:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: jbarnes@virtuousgeek.org, eric@anholt.net, airlied@redhat.com,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq, intel_fb: fix sysrq g collision
Message-Id: <20090514161747.e8683c9e.akpm@linux-foundation.org>
In-Reply-To: <4A0CA203.7050907@windriver.com>
References: <4A0CA203.7050907@windriver.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 17:58:11 -0500
Jason Wessel <jason.wessel@windriver.com> wrote:

> Commit 79e539453b34e35f39299a899d263b0a1f1670bd introduced a
> regression where you cannot use sysrq 'g' to enter kgdb.  The solution
> is to move the intel fb sysrq over to V for video instead of G for
> graphics.  The SMP VOYAGER code to register for the sysrq-v is not
> anywhere to be found in the mainline kernel, so the comments in the
> code were cleaned up as well.
> 
> This patch also cleans up the sysrq definitions for kgdb to make it
> generic for the kernel debugger, such that the sysrq 'g' can be used
> in the future to enter a gdbstub or another kernel debugger.
> 

I was looking at that a week or two ago.

> 
> --- a/drivers/char/sysrq.c
> +++ b/drivers/char/sysrq.c
> @@ -406,7 +406,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
>  	&sysrq_showlocks_op,		/* d */
>  	&sysrq_term_op,			/* e */
>  	&sysrq_moom_op,			/* f */
> -	/* g: May be registered by ppc for kgdb */
> +	/* g: May be registered for the kernel debugger */

And I made the mistake of believing the comment :(
