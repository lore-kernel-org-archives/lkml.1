Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYGLCb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYGLCb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 22:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYGLCbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 22:31:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109AbYGLCbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 22:31:20 -0400
Date: Fri, 11 Jul 2008 19:30:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       <sparclinux@vger.kernel.org>
Subject: Re: Remove init_mm export as planned for 2.6.26
Message-Id: <20080711193046.89b4b68a.akpm@linux-foundation.org>
In-Reply-To: <20080711201959.GA1007@redhat.com>
References: <20080711201959.GA1007@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 16:19:59 -0400 Dave Jones <davej@redhat.com> wrote:

> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 46ece3f..5e89689 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -270,18 +270,6 @@ Who:	Michael Buesch <mb@bu3sch.de>
>  
>  ---------------------------
>  
> -What:	init_mm export
> -When:	2.6.26
> -Why:	Not used in-tree. The current out-of-tree users used it to
> -	work around problems in the CPA code which should be resolved
> -	by now. One usecase was described to provide verification code
> -	of the CPA operation. That's a good idea in general, but such
> -	code / infrastructure should be in the kernel and not in some
> -	out-of-tree driver.
> -Who:	Thomas Gleixner <tglx@linutronix.de>
> -
> -----------------------------
> -
>  What:	usedac i386 kernel parameter
>  When:	2.6.27
>  Why:	replaced by allowdac and no dac combination
> diff --git a/arch/x86/kernel/init_task.c b/arch/x86/kernel/init_task.c
> index a4f93b4..d399180 100644
> --- a/arch/x86/kernel/init_task.c
> +++ b/arch/x86/kernel/init_task.c
> @@ -14,7 +14,6 @@ static struct fs_struct init_fs = INIT_FS;
>  static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
>  static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
>  struct mm_struct init_mm = INIT_MM(init_mm);
> -EXPORT_UNUSED_SYMBOL(init_mm); /* will be removed in 2.6.26 */
>  
>  /*
>   * Initial thread structure.
> 

grep -r init_mm include/asm-sparc64

This patch used to break stuff.  I'm not aware that anything was done
to prevent this.

