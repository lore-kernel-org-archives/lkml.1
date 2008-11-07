Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYKGBBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYKGBBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYKGBBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:01:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453AbYKGBBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:01:17 -0500
Date: Thu, 6 Nov 2008 17:00:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: h-shimamoto@ct.jp.nec.com, ananth@in.ibm.com, laijs@cn.fujitsu.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes: bugfix: try_module_get even if calling_mod is
 NULL
Message-Id: <20081106170023.d5349c42.akpm@linux-foundation.org>
In-Reply-To: <49123521.6020608@redhat.com>
References: <490FE405.1000105@cn.fujitsu.com>
	<4910F697.2050203@redhat.com>
	<4910FB3D.4020805@cn.fujitsu.com>
	<491212C0.4030900@redhat.com>
	<4912222F.9040605@ct.jp.nec.com>
	<49122745.4090004@redhat.com>
	<49123521.6020608@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2008 19:06:57 -0500
Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Get probed module even if the caller is in the kernel core code.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
> 
> >> One question, off topic.
> >> If calling_mod is NULL, no try_module_get(), is that OK?
> >
> > Good question. Currently, kprobes is called only from kernel modules,
> > so calling_mod should be always !NULL.
> > However, it should be fixed, because the logic is not correct.
> 
> Thank you so much. So here is the additional bugfix patch.
> 
>  kernel/kprobes.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: 2.6.28-rc3/kernel/kprobes.c
> ===================================================================
> --- 2.6.28-rc3.orig/kernel/kprobes.c
> +++ 2.6.28-rc3/kernel/kprobes.c
> @@ -634,7 +634,7 @@ static int __kprobes __register_kprobe(s
>  		 * avoid incrementing the module refcount, so as to allow
>  		 * unloading of self probing modules.
>  		 */
> -		if (calling_mod && calling_mod != probed_mod) {
> +		if (calling_mod != probed_mod) {
>  			if (unlikely(!try_module_get(probed_mod))) {
>  				preempt_enable();
>  				return -EINVAL;
> 

I do not understand this description "Get probed module even if the
caller is in the kernel core code".

What bug is being fixed here?  What is the kernel behaviour before and
after the patch?

Was the bug present in 2.6.27, 2.6.26 etc?  Or was it a post-2.6.28
regression?

