Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbZCMPET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbZCMPET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756981AbZCMPEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:04:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50279 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbZCMPEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:04:04 -0400
Message-ID: <49BA75CF.3040501@us.ibm.com>
Date: Fri, 13 Mar 2009 08:03:43 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/futexes] futex: remove the pointer math from double_unlock_hb,
 fix
References: <20090312221118.11146.68610.stgit@Aeon> <tip-88f502fedba82eff252b6420e8b8328e4ae25c67@git.kernel.org>
In-Reply-To: <tip-88f502fedba82eff252b6420e8b8328e4ae25c67@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Commit-ID:  88f502fedba82eff252b6420e8b8328e4ae25c67
> Gitweb:     http://git.kernel.org/tip/88f502fedba82eff252b6420e8b8328e4ae25c67
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Fri, 13 Mar 2009 10:32:07 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 13 Mar 2009 10:32:07 +0100
> 
> futex: remove the pointer math from double_unlock_hb, fix
> 
> Impact: fix double unlock crash
> 
> Thomas Gleixner noticed that the simplified double_unlock_hb()
> became ... too unsophisticated: in the hb1 == hb2 case it will
> do a double unlock.

Gah.  Thanks for catching it.

> 
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Darren Hart <dvhltc@us.ibm.com>
> LKML-Reference: <20090312221118.11146.68610.stgit@Aeon>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Darren Hart <dvhltc@us.ibm.com>

> 
> 
> ---
>  kernel/futex.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 2331b73..6b50a02 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -659,7 +659,8 @@ static inline void
>  double_unlock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
>  {
>  	spin_unlock(&hb1->lock);
> -	spin_unlock(&hb2->lock);
> +	if (hb1 != hb2)
> +		spin_unlock(&hb2->lock);
>  }
> 
>  /*


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
