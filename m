Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0CFSsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 13:48:06 -0500
Received: from bob75-7-88-160-5-175.fbx.proxad.net ([88.160.5.175]:56851 "EHLO
	cerbere.dyndns.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab0CFSsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 13:48:01 -0500
From: Samir Bellabes <sam@synack.fr>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, hadi@cyberus.ca, kaber@trash.net,
       zbr@ioremap.net, nhorman@tuxdriver.com, root@localdomain.pl,
       linux-security-module@vger.kernel.org
Subject: Re: [RFC v2 00/10] snet: Security for NETwork syscalls
References: <1267561394-13626-1-git-send-email-sam@synack.fr>
	<201003030156.o231udx1023055@www262.sakura.ne.jp>
Date: Sat, 06 Mar 2010 19:47:56 +0100
In-Reply-To: <201003030156.o231udx1023055@www262.sakura.ne.jp> (Tetsuo Handa's
	message of "Wed, 03 Mar 2010 10:56:39 +0900")
Message-ID: <m2vdd9p9r7.fsf@ssh.synack.fr>
User-Agent: Gnus/5.110003 (No Gnus v0.3) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> Regarding [RFC v2 09/10] snet: introduce snet_ticket
> +enum snet_verdict snet_ticket_check(struct snet_info *info)
> +{
> +       struct snet_ticket *st = NULL;
> +       unsigned int h = 0, verdict = SNET_VERDICT_NONE;
> +       struct list_head *l = NULL;
> +       struct snet_task_security *tsec = NULL;
> +
> +       if (snet_ticket_mode == SNET_TICKET_OFF)
> +               goto out;
> +
> +       tsec = (struct snet_task_security*) current_security();
> +
> +       h = jhash_2words(info->syscall, info->protocol, 0) % HSIZE;
> +       l = &tsec->hash[h];
> +
> +       read_lock_bh(&tsec->lock);
>
> Credentials are allocated for copy-on-write basis.
> Sharing "tsec" among multiple "struct task_struct" is what you intended?

No, there is no shared "tsec".
snet_ticket_check() is called from the process context. So "tsec" is
a pointer to the "void *security" pointer from its own "struct
task_struct".

every task_struct have a "tsec" allocated to its "void *security"
pointer. 

I will take a second look on how to access the credentials COW.

> Regards.

Tetsuo, thank you again for reviewing.
sam
