Return-Path: <linux-kernel-owner+w=401wt.eu-S1764665AbYHDVDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764665AbYHDVDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764230AbYHDVCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:02:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14944 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbYHDVCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:02:18 -0400
Date: Mon, 4 Aug 2008 14:00:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracehook: kerneldoc fix
Message-Id: <20080804140030.b1964c50.randy.dunlap@oracle.com>
In-Reply-To: <20080804205601.4C6ED154252@magilla.localdomain>
References: <20080804205601.4C6ED154252@magilla.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Aug 2008 13:56:01 -0700 (PDT) Roland McGrath wrote:

> My last change to tracehook.h made it confuse the kerneldoc parser.
> Move the #define's before the comment so it's happy again.

Ack.  Thanks for noticing/fixing.

> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  include/linux/tracehook.h |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
> index 1253283..ab3ef7a 100644
> --- a/include/linux/tracehook.h
> +++ b/include/linux/tracehook.h
> @@ -487,6 +487,9 @@ static inline int tracehook_notify_jctl(int notify, int why)
>  	return notify || (current->ptrace & PT_PTRACED);
>  }
>  
> +#define DEATH_REAP			-1
> +#define DEATH_DELAYED_GROUP_LEADER	-2
> +
>  /**
>   * tracehook_notify_death - task is dead, ready to notify parent
>   * @task:		@current task now exiting
> @@ -501,8 +504,6 @@ static inline int tracehook_notify_jctl(int notify, int why)
>   *
>   * Called with write_lock_irq(&tasklist_lock) held.
>   */
> -#define DEATH_REAP			-1
> -#define DEATH_DELAYED_GROUP_LEADER	-2
>  static inline int tracehook_notify_death(struct task_struct *task,
>  					 void **death_cookie, int group_dead)
>  {
> --

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
