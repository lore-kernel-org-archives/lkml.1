Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbYHEP62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbYHEP62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758781AbYHEP6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:58:18 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:54098 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758302AbYHEP6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:58:18 -0400
Message-ID: <4898785E.1010702@s5r6.in-berlin.de>
Date: Tue, 05 Aug 2008 17:57:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Make kthread_stop() not oops when passed a bad pointer
References: <20080805135559.GQ26461@parisc-linux.org>
In-Reply-To: <20080805135559.GQ26461@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -201,6 +201,9 @@ int kthread_stop(struct task_struct *k)
>  {
>  	int ret;
>  
> +	if (!k || IS_ERR(k))
> +		return -EINVAL;
> +
>  	mutex_lock(&kthread_stop_lock);
>  
>  	/* It could exit after stop_info.k set, but before wake_up_process. */

Would
	if (WARN_ON(!k || IS_ERR(k)))

be in order, or are there valid cases of passing an invalid pointer?
-- 
Stefan Richter
-=====-==--- =--- --=-=
http://arcgraph.de/sr/
