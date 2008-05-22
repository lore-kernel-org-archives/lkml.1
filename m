Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbYEVFRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbYEVFRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 01:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYEVFQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 01:16:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbYEVFQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 01:16:53 -0400
Date: Wed, 21 May 2008 22:15:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Shi Weihua <shiwh@cn.fujitsu.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jmorris@namei.org,
       ltp-list@lists.sourceforge.net
Subject: Re: [PATCH] fix sys_prctl() returned uninitialized value
Message-Id: <20080521221536.204da871.akpm@linux-foundation.org>
In-Reply-To: <4834FE1D.10909@kernel.org>
References: <4834E639.2010209@cn.fujitsu.com>
	<20080521203212.ddf05254.akpm@linux-foundation.org>
	<4834FE1D.10909@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 22:01:17 -0700 "Andrew G. Morgan" <morgan@kernel.org> wrote:

> this is the default expected by the subsequent switch ().
> 

oh gawd.

> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 895d2d4..cb25a64 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1657,6 +1657,8 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
>  	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
>  		return error;

All along I was believing that it was _this_ return which was causing
the problem.

> +	error = 0;
> +
>  	switch (option) {
>  		case PR_SET_PDEATHSIG:
>  			if (!valid_signal(arg2)) {

But now I see it.


This was a hard way to write a changelog.
