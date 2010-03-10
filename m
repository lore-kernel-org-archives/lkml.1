Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0CJJnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:43:41 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49101 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755602Ab0CJJnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:43:39 -0500
Date: Wed, 10 Mar 2010 10:43:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] freezer: only show the state of tasks refusing to
	freeze
Message-ID: <20100310094337.GA19370@atrey.karlin.mff.cuni.cz>
References: <1268213322-5094-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268213322-5094-1-git-send-email-dfeng@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> show_state will dump all tasks state, so if freezer failed to freeze
> any task, kernel will dump all tasks state and flood the dmesg log.
> This patch makes freezer only show state of tasks refusing to freeze.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Pavel Machek <pavel@ucw.cz>

ACK.

> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 5ade1bd..a0480cd 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -88,12 +88,11 @@ static int try_to_freeze_tasks(bool sig_only)
>  		printk(KERN_ERR "Freezing of tasks failed after %d.%02d seconds "
>  				"(%d tasks refusing to freeze):\n",
>  				elapsed_csecs / 100, elapsed_csecs % 100, todo);
> -		show_state();
>  		read_lock(&tasklist_lock);
>  		do_each_thread(g, p) {
>  			task_lock(p);
>  			if (freezing(p) && !freezer_should_skip(p))
> -				printk(KERN_ERR " %s\n", p->comm);
> +				sched_show_task(p);
>  			cancel_freezing(p);
>  			task_unlock(p);
>  		} while_each_thread(g, p);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
