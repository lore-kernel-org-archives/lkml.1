Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbZK0Ck4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbZK0Ck4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 21:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbZK0Ckz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 21:40:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39751 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbZK0Cky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 21:40:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hmsdTgAE+ktGLOGdVOmMvhdatgyJQJUhIpD/DJaPeeE8QluVbEoJrxenvbuPTY3AwY
         zmNpNAqiei3av/zVgh1fafi2EZiSEkQHn7HKclGE2l6y32aXQJMUumQWjYR8dTTlMybt
         Zc0Uf0BwRf/xnZ3N8gJ6N5Dirmywov7i5zMIc=
Date: Fri, 27 Nov 2009 03:40:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, msb@google.com
Subject: Re: PATCH: softlockup: Fix hung_task_check_count sysctl
Message-ID: <20091127024054.GA5406@nowhere>
References: <20091127022820.GU32182@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127022820.GU32182@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 01:28:20PM +1100, Anton Blanchard wrote:
> 
> I'm seeing spikes of up to 0.5ms in khungtaskd on a large machine. To reduce
> this source of jitter I tried setting hung_task_check_count to 0:
> 
> # echo 0 > /proc/sys/kernel/hung_task_check_count
> 
> which didn't have the intended response. Change to a post increment of
> max_count, so a value of 0 means check 0 tasks.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
> 
> Index: linux.trees.git/kernel/hung_task.c
> ===================================================================
> --- linux.trees.git.orig/kernel/hung_task.c	2009-11-27 13:11:46.000000000 +1100
> +++ linux.trees.git/kernel/hung_task.c	2009-11-27 13:11:57.000000000 +1100
> @@ -144,7 +144,7 @@ static void check_hung_uninterruptible_t
>  
>  	rcu_read_lock();
>  	do_each_thread(g, t) {
> -		if (!--max_count)
> +		if (!max_count--)
>  			goto unlock;
>  		if (!--batch_count) {
>  			batch_count = HUNG_TASK_BATCHING;

