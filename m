Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbXJJBtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbXJJBtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 21:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbXJJBtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 21:49:31 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:35438 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbXJJBtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 21:49:31 -0400
Message-ID: <470C2FA7.5030207@davidnewall.com>
Date: Wed, 10 Oct 2007 11:19:27 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Gustavo Chain <g@0xff.cl>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reserve N process to root
References: <20071009194820.6c8d6e8d@0xff.cl>
In-Reply-To: <20071009194820.6c8d6e8d@0xff.cl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gustavo Chain wrote:
> I think it's necessary to reserve some pids to the super user.
> 5 must be sufficient.

Why?  (Sorry if I missed something.)

Shouldn't you test for error return before the pid is allocated?  
Otherwise, I think, you have to free it.  Thus:
>  long do_fork(unsigned long clone_flags,
>               int __user *parent_tidptr,
>               int __user *child_tidptr)
>  {
> +#define RESERVED_PIDS   5      /* danged if I know why */
> +
> +       if (!capable(CAP_SYS_ADMIN) && nr_threads >= max_threads - RESERVED_PIDS)
> +               return -EAGAIN;
> +
>
>         struct task_struct *p;
>         int trace = 0;
>         struct pid *pid = alloc_pid();
>         long nr;
>  
>         if (!pid)
>                 return -EAGAIN;
>         nr = pid->nr;
>   

(While I'm being picky, I don't like braces around a simple return, and 
neither, I note, does the style guide.)
