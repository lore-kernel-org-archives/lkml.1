Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbXKCJDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbXKCJDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 05:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbXKCJDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 05:03:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:39692 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325AbXKCJDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 05:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YHNtU7dylx1KOu3VBgWNpGdj9B3qKpU5tnAf0aULsrnpurgcnpAxTOv+LkizBSLsiTe02yW3YSX0rmqiPdPooVwOaWCfDtLs4HSkb1mnWsIL3MIBwLt1enLfatbKELjSp9tpMYCTBvrGknyi8m1WY944/KQAeDo7l/WrUVT5uG8=
Message-ID: <661de9470711030202x24d0186cuc96a70156ecfa23f@mail.gmail.com>
Date: Sat, 3 Nov 2007 14:32:59 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [PATCH] Restore deterministic CPU accounting on powerpc
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "Christian Borntraeger" <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <18218.44089.274628.680088@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18218.44089.274628.680088@cargo.ozlabs.ibm.com>
X-Google-Sender-Auth: 37ee135d273c4587
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifndef CONFIG_VIRT_CPU_ACCOUNTING
> +void account_process_tick(int user_tick)
> +{
> +       if (user_tick) {
> +               account_user_time(p, jiffies_to_cputime(1));
> +               account_user_time_scaled(p, jiffies_to_cputime(1));
> +       } else {
> +               account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
> +               account_system_time_scaled(p, jiffies_to_cputime(1));
> +       }
> +}
> +#endif
> +

Hi, Paul,

So, scaled accounting will not be available if
CONFIG_VIRT_CPU_ACCOUNTING is defined? Am I reading this correctly

Balbir Singh
