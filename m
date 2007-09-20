Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbXITJCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbXITJCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 05:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbXITJCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 05:02:35 -0400
Received: from sacred.ru ([62.205.161.221]:52224 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbXITJCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 05:02:35 -0400
Message-ID: <46F23681.2030400@openvz.org>
Date: Thu, 20 Sep 2007 12:59:45 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc6-mm1 - make access to tasks nsproxy ligther (fix)
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F2324E.9020707@fr.ibm.com>
In-Reply-To: <46F2324E.9020707@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 20 Sep 2007 13:02:10 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks sane :)

[snip]

> Index: 2.6.23-rc6-mm1/kernel/exit.c
> ===================================================================
> --- 2.6.23-rc6-mm1.orig/kernel/exit.c
> +++ 2.6.23-rc6-mm1/kernel/exit.c
> @@ -408,6 +408,8 @@ void daemonize(const char *name, ...)
>  	current->fs = fs;
>  	atomic_inc(&fs->count);
>  
> +	if (current->nsproxy != init_task.nsproxy)
> +		get_nsproxy(init_task.nsproxy);
>  	switch_task_namespaces(current, init_task.nsproxy);

shouldn't we make the switch under this if() as well?
