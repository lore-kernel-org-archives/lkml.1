Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbZDMSxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbZDMSxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbZDMSxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:53:16 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:7803 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbZDMSxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AqhVTwmPL1TGH6Wn7K4Lx2FUUW/8BPE08/CY3qdKY4/qjmCKsxURYJAROeZkFPgwCv
         /vctUD5DWpLlAJVedS+J3aUhS3sI6wy+zyc1944ztNcudofn6U+J/44+otdWZU/wOj2l
         Ca/uvGTZgT5eRrvnqV0gsLGx/5lIz32lMU6kM=
MIME-Version: 1.0
In-Reply-To: <tip-46e0bb9c12f4bab539736f1714cbf16600f681ec@git.kernel.org>
References: <20090330045520.2869.24777.stgit@sofia.in.ibm.com>
	 <tip-46e0bb9c12f4bab539736f1714cbf16600f681ec@git.kernel.org>
Date: Mon, 13 Apr 2009 11:53:13 -0700
X-Google-Sender-Auth: 824913e8327064f1
Message-ID: <12c511ca0904131153g39b99ec6n6c6ec2e7de3f7ea6@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Print sched_group::__cpu_power in 
	sched_domain_debug
From: Tony Luck <tony.luck@intel.com>
To: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6963,7 +6963,8 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
>                cpumask_or(groupmask, groupmask, sched_group_cpus(group));
>
>                cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
> -               printk(KERN_CONT " %s", str);
> +               printk(KERN_CONT " %s (__cpu_power = %d)", str,
> +                                               group->__cpu_power);

This has added a lot of clutter to the console log during boot
(especially on large systems).

Here is the start of the diff output comparing old and new console
messages on a 16 cpu machine:

77c77
<   groups: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
---
>   groups: 0 (__cpu_power = 1024) 1 (__cpu_power = 1024) 2 (__cpu_power = 1024) 3 (__cpu_power = 1024) 4 (__cpu_power = 1024) 5 (__cpu_power = 1024) 6 (__cpu_power = 1024) 7 (__cpu_power = 1024) 8 (
__cpu_power = 1024) 9 (__cpu_power = 1024) 10 (__cpu_power = 1024) 11
(__cpu_power = 1024) 12 (__cpu_power = 1024) 13 (__cpu_power = 1024)
14 (__cpu_power = 1024) 15 (__cpu_power = 1024)
80c80
<   groups: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 0
---
>   groups: 1 (__cpu_power = 1024) 2 (__cpu_power = 1024) 3 (__cpu_power = 1024) 4 (__cpu_power = 1024) 5 (__cpu_power = 1024) 6 (__cpu_power = 1024) 7 (__cpu_power = 1024) 8 (__cpu_power = 1024) 9 (
__cpu_power = 1024) 10 (__cpu_power = 1024) 11 (__cpu_power = 1024) 12
(__cpu_power = 1024) 13 (__cpu_power = 1024) 14 (__cpu_power = 1024)
15 (__cpu_power = 1024) 0 (__cpu_power = 1024)

continues as each group is reported.

-Tony
