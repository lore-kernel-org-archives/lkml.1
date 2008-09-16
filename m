Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYIPFmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYIPFmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 01:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYIPFma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 01:42:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36237 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYIPFm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 01:42:29 -0400
Date: Tue, 16 Sep 2008 07:42:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Steven Noonan <steven@uplinklabs.net>
Subject: Re: [PATCH -tip] uaccess: fix parameters inversion for
	__copy_from_user_inatomic()
Message-ID: <20080916054216.GA13741@elte.hu>
References: <48CF061A.5060002@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CF061A.5060002@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> The following patch changes to use __copy_from_user_inatomic(),
> but the passing parameters incorrect.
> 
>     x86: some lock annotations for user copy paths, v3
> 
>     - add annotation back to clear_user()
>     - change probe_kernel_address() to _inatomic*() method
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  include/linux/uaccess.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index 2062293..6b58367 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -78,7 +78,7 @@ static inline unsigned long __copy_from_user_nocache(void *to,
>  							\
>  		set_fs(KERNEL_DS);			\
>  		pagefault_disable();			\
> -		ret = __copy_from_user_inatomic((__force typeof(retval) __user *)(addr), &(retval), sizeof(retval));		\
> +		ret = __copy_from_user_inatomic(&(retval), (__force typeof(retval) __user *)(addr), sizeof(retval));		\

*blush*. Thanks!

	Ingo
