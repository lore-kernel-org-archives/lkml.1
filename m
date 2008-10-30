Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYJ3Rgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYJ3Rgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYJ3Rgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:36:44 -0400
Received: from hs-out-0708.google.com ([64.233.178.246]:53501 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbYJ3Rgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:36:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LlYN5xNaLbppA3CW7afU5FCWAiBpHjf76JT9zIrN/Rk42XxUJVvGr/A6if8lBxBOV+
         59s+66tR97G0Wa6Z4yhGoTC4FMzQiQIEn7K6Z053YHdPVz4xQpxKdhQiKIe95vupoDlW
         EMWCDICuuAVZZFGTVGSFrfuBIZO91Mwnm3mCQ=
Message-ID: <12c511ca0810301036o4d2e3960k1159a40b7401ca2b@mail.gmail.com>
Date: Thu, 30 Oct 2008 10:36:41 -0700
From: "Tony Luck" <tony.luck@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 29/35] cpumask: switch over to cpu_online/possible/active/present_mask From: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081023020832.084887000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
	 <20081023020832.084887000@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
...
+#define cpu_online_map		(*(cpumask_t *)cpu_online_mask)

This bit seems to be the reason why linux-next isn't building for ia64
(tag next-20081029
and next-20081030). With this error:

>   CC      arch/ia64/kernel/asm-offsets.s
> In file included from include/linux/smp.h:30,
>                  from include/linux/sched.h:68,
>                  from arch/ia64/kernel/asm-offsets.c:9:
> arch/ia64/include/asm/smp.h:60: error: expected ')' before '*' token
> arch/ia64/include/asm/smp.h:60: error: expected ')' before 'cpu_online_mask'

Fix is trivial ... delete the declaration of cpu_online_map from
arch/ia64/include/asm/smp.h

-Tony
