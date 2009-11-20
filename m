Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZKTGKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZKTGKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 01:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZKTGKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 01:10:42 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:64668 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbZKTGKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 01:10:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FDVcs/E+tWPNF8K57dZrI79NzEz4mZ22fm8cCujKppjZHz208FTOIJluNGMip01RSc
         DOY1V1GeuQWdjt8cAckLqoY+AOSF+XP1xcIzsGmIrmUnvonzqndwrfIV6x/YUs942mQ7
         aVFJ9gaDZwJnVuPweGBA9rFRxw3uLhqJ67Zno=
MIME-Version: 1.0
In-Reply-To: <1258555922-2064-12-git-send-email-jslaby@novell.com>
References: <4B040A03.2020508@gmail.com>
	 <1258555922-2064-12-git-send-email-jslaby@novell.com>
Date: Fri, 20 Nov 2009 14:10:46 +0800
Message-ID: <2375c9f90911192210o55b69d49nda5281b4662f916a@mail.gmail.com>
Subject: Re: [PATCH 12/16] core: rename setrlimit to do_setrlimit
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Jiri Slaby <jslaby@novell.com>
Cc: jirislaby@gmail.com, mingo@elte.hu, nhorman@tuxdriver.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, torvalds@linux-foundation.org,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 10:51 PM, Jiri Slaby <jslaby@novell.com> wrote:
> Rename it so that it makes more sense in the field of syscalls
> (i.e. do_* is used for functions called by syscall wrappers but
> also when called from other paths).
>
> Signed-off-by: Jiri Slaby <jslaby@novell.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@elte.hu>


Sounds good.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

> ---
>  fs/proc/base.c           |    2 +-
>  include/linux/resource.h |    2 +-
>  kernel/sys.c             |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index b894170..c6589fb 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -576,7 +576,7 @@ static ssize_t limits_write(struct file *file, const char __user *buf,
>                goto put_task;
>        }
>
> -       ret = setrlimit(task, i, &new_rlimit);
> +       ret = do_setrlimit(task, i, &new_rlimit);
>        if (ret)
>                count = ret;
>
> diff --git a/include/linux/resource.h b/include/linux/resource.h
> index 4301d67..08beb1a 100644
> --- a/include/linux/resource.h
> +++ b/include/linux/resource.h
> @@ -71,7 +71,7 @@ struct rlimit {
>  #include <asm/resource.h>
>
>  int getrusage(struct task_struct *p, int who, struct rusage __user *ru);
> -int setrlimit(struct task_struct *tsk, unsigned int resource,
> +int do_setrlimit(struct task_struct *tsk, unsigned int resource,
>                struct rlimit *new_rlim);
>
>  #endif
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 52200d4..4db6ba6 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1239,7 +1239,7 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
>  #endif
>
>  /* make sure you are allowed to change @tsk limits before calling this */
> -int setrlimit(struct task_struct *tsk, unsigned int resource,
> +int do_setrlimit(struct task_struct *tsk, unsigned int resource,
>                struct rlimit *new_rlim)
>  {
>        struct rlimit *old_rlim;
> @@ -1308,7 +1308,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
>                return -EINVAL;
>        if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
>                return -EFAULT;
> -       return setrlimit(current, resource, &new_rlim);
> +       return do_setrlimit(current, resource, &new_rlim);
>  }
>
>  /*
