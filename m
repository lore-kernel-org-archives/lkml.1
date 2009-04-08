Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZDHH0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZDHH0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760730AbZDHH0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:26:13 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:62647 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761518AbZDHH0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:26:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wUVe5w8t/G4Bk+xzLrRv+QR2H8rodyYfWYN4OrwuvdcrTfyR30AJQXNb6B5t1lwgNS
         q0v9rtYO0yKSQKmYH5ozB4sBujVH+/RfaUBWlJYarUANLuUGRa49PkQl1SwCz0GXnT7Q
         yazEpjfDPP8okjYtByGADYcVxHas76gW+iE0o=
MIME-Version: 1.0
In-Reply-To: <20090408062106.39EE0FC3E5@magilla.sf.frob.com>
References: <20090408062106.39EE0FC3E5@magilla.sf.frob.com>
Date: Wed, 8 Apr 2009 04:26:08 -0300
Message-ID: <ce0170d90904080026x4e292ce7sfae4eea70eb386cd@mail.gmail.com>
Subject: Re: [PATCH] ptrace: checkpatch fixes
From: Sergio Luis <eeeesti@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 3:21 AM, Roland McGrath <roland@redhat.com> wrote:
> This fixes all the checkpatch --file complaints about kernel/ptrace.c
> and also removes an unused #include.  I've verified that there are no
> changes to the compiled code on x86_64.

silly question, but... how do you verify that? is there any tool under
scripts/ that do that comparison?

thanks,
sergio

>
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  kernel/ptrace.c |   25 +++++++++++++------------
>  1 files changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index aaad0ec..dbe79ef 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -21,9 +21,7 @@
>  #include <linux/audit.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/syscalls.h>
> -
> -#include <asm/pgtable.h>
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>
>
>  /*
> @@ -48,7 +46,7 @@ void __ptrace_link(struct task_struct *child, struct task_struct *new_parent)
>        list_add(&child->ptrace_entry, &new_parent->ptraced);
>        child->parent = new_parent;
>  }
> -
> +
>  /*
>  * Turn a tracing stop into a normal stop now, since with no tracer there
>  * would be no way to wake it up with SIGCONT or SIGKILL.  If there was a
> @@ -173,7 +171,7 @@ bool ptrace_may_access(struct task_struct *task, unsigned int mode)
>        task_lock(task);
>        err = __ptrace_may_access(task, mode);
>        task_unlock(task);
> -       return (!err ? true : false);
> +       return !err;
>  }
>
>  int ptrace_attach(struct task_struct *task)
> @@ -338,7 +336,8 @@ void exit_ptrace(struct task_struct *tracer)
>        }
>  }
>
> -int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len)
> +int ptrace_readdata(struct task_struct *tsk, unsigned long src,
> +                   char __user *dst, int len)
>  {
>        int copied = 0;
>
> @@ -358,12 +357,13 @@ int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst
>                copied += retval;
>                src += retval;
>                dst += retval;
> -               len -= retval;
> +               len -= retval;
>        }
>        return copied;
>  }
>
> -int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len)
> +int ptrace_writedata(struct task_struct *tsk, char __user *src,
> +                    unsigned long dst, int len)
>  {
>        int copied = 0;
>
> @@ -383,7 +383,7 @@ int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long ds
>                copied += retval;
>                src += retval;
>                dst += retval;
> -               len -= retval;
> +               len -= retval;
>        }
>        return copied;
>  }
> @@ -496,9 +496,9 @@ static int ptrace_resume(struct task_struct *child, long request, long data)
>                if (unlikely(!arch_has_single_step()))
>                        return -EIO;
>                user_enable_single_step(child);
> -       }
> -       else
> +       } else {
>                user_disable_single_step(child);
> +       }
>
>        child->exit_code = data;
>        wake_up_process(child);
> @@ -527,7 +527,8 @@ int ptrace_request(struct task_struct *child, long request,
>                ret = ptrace_setoptions(child, data);
>                break;
>        case PTRACE_GETEVENTMSG:
> -               ret = put_user(child->ptrace_message, (unsigned long __user *) data);
> +               ret = put_user(child->ptrace_message,
> +                              (unsigned long __user *) data);
>                break;
>
>        case PTRACE_GETSIGINFO:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
