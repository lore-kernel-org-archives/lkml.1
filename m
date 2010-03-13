Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab0CMMFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:05:21 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:53413 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab0CMMFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:05:19 -0500
To: error27@gmail.com, jmorris@namei.org
Cc: takedakn@nttdata.co.jp, serue@us.ibm.com, haradats@nttdata.co.jp,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] tomoyo: fix potential use after free
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20100313111422.GA2594@bicker>
In-Reply-To: <20100313111422.GA2594@bicker>
Message-Id: <201003132105.CDF15561.OVOFHStLJFFQMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 13 Mar 2010 21:05:13 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:

> The original code returns a freed pointer.  This function is expected to 
> return NULL on errors.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Oh, thank you.
James, please send this patch to 2.6.34-rc1 .

Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

> diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
> index ff51f10..ef89947 100644
> --- a/security/tomoyo/common.c
> +++ b/security/tomoyo/common.c
> @@ -886,6 +886,7 @@ static struct tomoyo_profile *tomoyo_find_or_assign_new_profile(const unsigned
>  	ptr = kmalloc(sizeof(*ptr), GFP_KERNEL);
>  	if (!tomoyo_memory_ok(ptr)) {
>  		kfree(ptr);
> +		ptr = NULL;
>  		goto ok;
>  	}
>  	for (i = 0; i < TOMOYO_MAX_CONTROL_INDEX; i++)
