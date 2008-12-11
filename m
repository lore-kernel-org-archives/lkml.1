Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYLKTLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYLKTLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbYLKTLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:11:04 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:43484 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbYLKTLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:11:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ehCf5zQ7igk+uAPc0NY+HQOpfG99RQs8AyEZa91GxpCH/IKoFNiP8dyrKnsJHrixGB
         eTUTfUKtWbZAHuR1+mYFN4oe7j79Jxw5ymXrOmQ9RiWNTkL4Lvh7LOnHt/bsxvHzkc1R
         t1h3vsnxvxlBA5FjQG1B3EdR0ZLTF5Yqh1l/c=
Message-ID: <12c511ca0812111111t2992dd2cw8b4d57ac57bd0700@mail.gmail.com>
Date: Thu, 11 Dec 2008 11:11:00 -0800
From: "Tony Luck" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] Performance Counters for Linux, v3
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephane Eranian" <eranian@googlemail.com>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Paul Mackerras" <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20081211155230.GA4230@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211155230.GA4230@elte.hu>
X-Google-Sender-Auth: 5fefb106ec6cbd48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>        /*
>         * Special "software" counters provided by the kernel, even if
>         * the hardware does not support performance counters. These
>         * counters measure various physical and sw events of the
>         * kernel (and allow the profiling of them as well):
>         */
>        PERF_COUNT_CPU_CLOCK            = -1,
>        PERF_COUNT_TASK_CLOCK           = -2,
>        /*
>         * Future software events:
>         */
>        /* PERF_COUNT_PAGE_FAULTS       = -3,
>           PERF_COUNT_CONTEXT_SWITCHES  = -4, */

  ...
> +[ Note: more hw_event_types are supported as well, but they are CPU
> +  specific and are enumerated via /sys on a per CPU basis. Raw hw event
> +  types can be passed in as negative numbers. For example, to count
> +  "External bus cycles while bus lock signal asserted" events on Intel
> +  Core CPUs, pass in a -0x4064 event type value. ]

It looks like you have an overlap here.  You are using some negative numbers
to denote your special software events, but also as "raw" hardware events.
What if these conflict?

-Tony
