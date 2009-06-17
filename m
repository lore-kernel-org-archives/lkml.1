Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbZFQORi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbZFQORi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZFQORa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:17:30 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60763 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbZFQOR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:17:29 -0400
Subject: Re: [PATCH]x86-tsc.c : fix compile warning
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: "Figo.zhang" <figo1802@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Sumit Panchasara <sumit.panchasara@einfochips.com>,
       "'Sachin P Sant'" <sachinp@linux.vnet.ibm.com>,
       "'H. Peter Anvin'" <hpa@zytor.com>, "'Frans Pop'" <elendil@planet.nl>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Balbir Singh'" <balbir@linux.vnet.ibm.com>
In-Reply-To: <bb33bcf20906170700i4a4ea802yf1da08e9870d6221@mail.gmail.com>
References: <1245247057.3312.2.camel@myhost>
	 <bb33bcf20906170700i4a4ea802yf1da08e9870d6221@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Wed, 17 Jun 2009 19:47:21 +0530
Message-Id: <1245248241.4870.12.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> fix compile warning:
> arch/x86/kernel/tsc.c: In function ‘time_cpufreq_notifier’:
> arch/x86/kernel/tsc.c:635: warning: ‘dummy’ may be used uninitialized in
> this function
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>

Hello Figo,

Please refer to the following links on discussion on this issue earlier:
http://lkml.org/lkml/2009/5/19/312
http://lkml.org/lkml/2009/5/19/301
http://lkml.org/lkml/2009/5/20/23

I tried to fix it in some other way.

Regards--
Subrata

> ---
> arch/x86/kernel/tsc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index ae3180c..e65492a 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -632,7 +632,7 @@ static int time_cpufreq_notifier(struct
> notifier_block *nb, unsigned long val,
>                                void *data)
>  {
>        struct cpufreq_freqs *freq = data;
> -       unsigned long *lpj, dummy;
> +       unsigned long *lpj, dummy = 0;
> 
>        if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
>                return 0;
> 


