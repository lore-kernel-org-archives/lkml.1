Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbZDGQ47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbZDGQ47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbZDGQ4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:56:50 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:22422 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZDGQ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:56:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QiRVG4gsAD1IsLJr1j9upZOcHWmrwtaGPkPmvCF1fUoMXH+n/xTCkp02lfDfEX/It9
         LlCYsu/Ynz+gS3JNbgDxwmsNvq0/r6RiqhKebQ8VgxOQ9t9DTaeSSssrqTMmU5shQHW/
         ijmQSFxAv0ecDbL6lTvfaQ4+mxE11UbqggOiE=
Date: Wed, 8 Apr 2009 00:57:36 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "figo.zhang" <figo.zhang@kolorific.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rdunlap@xenotime.net
Subject: Re: [PATCH]kernel/sched_fair.c: the comment of the
	calc_delta_fair() maybe not correctly
Message-ID: <20090407165736.GI12226@hack>
References: <20090407063306.64659F50054@mail.kolorific.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407063306.64659F50054@mail.kolorific.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 02:33:06PM +0800, figo.zhang wrote:
>the comment of the calc_delta_fair() maybe not correctly, should be
>delta *= NICE_O_LOAD/se->load
>
>Signed-off-by: figo.zhang <figo.zhang@kolorific.com>

Agreed.

But...


>
>diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>index 3816f21..5134b45 100644
>--- a/kernel/sched_fair.c
>+++ b/kernel/sched_fair.c
>@@ -386,7 +386,7 @@ int sched_nr_latency_handler(struct ctl_table
>*table, int write, #endif
> 
> /*
>- * delta /= w
>+ * delta *= NICE_O_LOAD/se->load

Is that an 'O' or '0'(zero)? It looks like an 'O' for me ...
Obviously, it should be '0' (zero). :)


>  */
> static inline unsigned long
> calc_delta_fair(unsigned long delta, struct sched_entity *se)
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Do what you love, f**k the rest! F**k the regulations!
 
