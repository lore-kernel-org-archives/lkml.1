Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbXEARwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbXEARwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbXEARwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:52:16 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:33158 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbXEARwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:52:13 -0400
Message-ID: <46377E43.8000605@linux.vnet.ibm.com>
Date: Tue, 01 May 2007 23:22:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: menage@google.com
CC: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, containers@lists.osdl.org,
       devel@openvz.org
Subject: Re: [PATCH 2/9] Containers (V9): Example CPU accounting subsystem
References: <20070427104607.252541000@menage.corp.google.com> <20070427111300.232406000@menage.corp.google.com>
In-Reply-To: <20070427111300.232406000@menage.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

menage@google.com wrote:
> +
> +/* Lazily update the load calculation if necessary. Called with ca locked */
> +static void cpuusage_update(struct cpuacct *ca)
> +{
> +	u64 now = get_jiffies_64();
> +	/* If we're not due for an update, return */
> +	if (ca->next_interval_check > now)
> +		return;
> +
> +	if (ca->next_interval_check <= (now - INTERVAL)) {

These two conditions seem a little confusing.

If ca->next_interval_check > (now - INTERVAL), the else part
is executed, but if ca->next_interval_check > (now - INTERVAL)
then ca->next_interval_check > now, which implies we return
and never enter the else part. It's been quite sometime since
I looked at this code, so I might have gotten it wrong.
I see a load of 0% on my powerpc box. I think it is because
last_interval_time is always 0, I'll debug further


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
