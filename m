Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbYEHHY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbYEHHY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbYEHHYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:24:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbYEHHYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:24:49 -0400
Message-ID: <4822AA6F.5040703@cn.fujitsu.com>
Date: Thu, 08 May 2008 15:23:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] call_usermodehelper_setup() should use GFP_KERNEL
References: <20080508153337.0EEE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080508153337.0EEE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Now, call_usermodehelper_setup() use GFP_ATOMIC.
> but it is slighly odd.
> because call_usermodehelper() is always called process context.
> 

Are you sure? I found the following call chain:

  static irqreturn_t power_handler(int irq, void *dev_id)
  ->orderly_poweroff(true);
    ->call_usermodehelper_setup()

> GFP_KERNEL is robust and better.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: "Paul Menage" <menage@google.com>
> CC: Li Zefan <lizf@cn.fujitsu.com>
> CC: Jeremy Fitzhardinge <jeremy@xensource.com>
> CC: Andi Kleen <ak@suse.de>
> CC: Rusty Russell <rusty@rustcorp.com.au> 
> 
> ---
>  kernel/kmod.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/kernel/kmod.c
> ===================================================================
> --- a/kernel/kmod.c	2008-04-29 17:37:41.000000000 +0900
> +++ b/kernel/kmod.c	2008-05-06 20:20:02.000000000 +0900
> @@ -360,7 +360,7 @@ struct subprocess_info *call_usermodehel
>  						  char **argv, char **envp)
>  {
>  	struct subprocess_info *sub_info;
> -	sub_info = kzalloc(sizeof(struct subprocess_info),  GFP_ATOMIC);
> +	sub_info = kzalloc(sizeof(struct subprocess_info),  GFP_KERNEL);
>  	if (!sub_info)
>  		goto out;
>  
> 
> 
> 
> 
