Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYGLQmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYGLQmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 12:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYGLQmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 12:42:09 -0400
Received: from [194.117.236.238] ([194.117.236.238]:35098 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYGLQmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 12:42:08 -0400
Date: Sat, 12 Jul 2008 19:40:38 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tom Zanussi <tzanussi@gmail.com>, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [mmotm] relay: fix build error
Message-ID: <20080712194038.5833d880@linux360.ro>
In-Reply-To: <20080712201206.F6B0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080712201206.F6B0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2008 20:14:21 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> against: mmotm
> patchname:
> relay-add-buffer-only-channels-useful-for-early-logging-fix.patch
> applies after:
> relay-add-buffer-only-channels-useful-for-early-logging.patch
> 
> recently, smp_call_function remove retry argument.
> it cause following build error on mmotm.
> 
> 	kernel/relay.c: In function ‘relay_late_setup_files’:
> 	kernel/relay.c:754: error: too many arguments to function
> ‘smp_call_function_single’ make[1]: *** [kernel/relay.o] error 1
> 
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>

Thanks.

If it matters...
Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

> ---
>  kernel/relay.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/kernel/relay.c
> ===================================================================
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -751,7 +751,7 @@ int relay_late_setup_files(struct rchan 
>  			/* relay_channels_mutex must be held, so
> wait. */ err = smp_call_function_single(i,
>  						       __relay_set_buf_dentry,
> -						       &disp, 0, 1);
> +						       &disp, 1);
>  		}
>  		if (unlikely(err))
>  			break;
> 
