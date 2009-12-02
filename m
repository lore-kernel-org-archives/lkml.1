Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZLBASe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZLBASe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZLBASd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:18:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754755AbZLBASc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:18:32 -0500
Date: Tue, 1 Dec 2009 16:18:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, dhowells@redhat.com,
       hidehiro.kawai.ez@hitachi.com, lethal@linux-sh.org, mingo@elte.hu,
       roland@redhat.com, vapier@gentoo.org,
       Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH v2] mm: Introduce coredump parameter structure
Message-Id: <20091201161800.fa6b6ae4.akpm@linux-foundation.org>
In-Reply-To: <4B11FB6F.4040403@redhat.com>
References: <200911202212.nAKMCF2v012068@imap1.linux-foundation.org>
	<20091126174835.5A73.A69D9226@jp.fujitsu.com>
	<4B0EA3AA.5070003@redhat.com>
	<20091126165108.GA13231@redhat.com>
	<4B11FB6F.4040403@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Nov 2009 23:41:19 -0500
Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Introduce coredump parameter data structure (struct coredump_params)
> for simplifying binfmt->core_dump() arguments.
> 
> Changes in v2:
>    - Don't remove DUMP_WRITE() macro.

What is the reason for this change?

Please always include both the "what" and the "why" in changelog text.

> diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
> index b639dcf..346b694 100644
> --- a/fs/binfmt_aout.c
> +++ b/fs/binfmt_aout.c
> @@ -32,7 +32,7 @@
> 
>     static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
>     static int load_aout_library(struct file*);
> -static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
> +static int aout_core_dump(struct coredump_params *cprm);
> 
>     static struct linux_binfmt aout_format = {
>     	.module		= THIS_MODULE,
> @@ -89,8 +89,9 @@ if (file->f_op->llseek) { \
>      * dumping of the process results in another error..
>      */
> 
> -static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
> +static int aout_core_dump(struct coredump_params *cprm)
>     {

Something horrid has mangled your patch.
