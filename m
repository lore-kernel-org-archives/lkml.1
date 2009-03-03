Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZCCMYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZCCMYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 07:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZCCMYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 07:24:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:35174 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZCCMYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 07:24:07 -0500
Subject: Re: [PATCH 2 2/3] sched: Fix the wakeup nomination for
 sched_mc/smt_power_savings.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, efault@gmx.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090303115149.605.92140.stgit@sofia.in.ibm.com>
References: <20090303114648.605.86920.stgit@sofia.in.ibm.com>
	 <20090303115149.605.92140.stgit@sofia.in.ibm.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 13:23:53 +0100
Message-Id: <1236083033.5330.4204.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 17:21 +0530, Gautham R Shenoy wrote:
> +/* Assign the sched-domain level which can nominate preferred wake-up cpu */
> +       rd->sched_mc_preferred_wakeup_cpu = UINT_MAX;
> +       rd->authorized_nomination_level = SD_LV_NONE;
> +
> +       if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP) {
> +               struct sched_domain *sd;
> +               enum sched_domain_level authorized_nomination_level =
> +                                                               SD_LV_NONE;
> +
> +               for_each_domain(first_cpu(*cpu_map), sd) {
> +                       if (!(sd->flags & SD_POWERSAVINGS_BALANCE))
> +                               continue;
> +                       authorized_nomination_level = sd->level;
> +               }
> +
> +               rd->authorized_nomination_level = authorized_nomination_level;
> +       }

Very odd looking comments there, and that enum init wrapping looks
weird. Either exceed 80 chars, or write it in a second line like:

 enum sched_domain_level authorized_nomination_level;

 authorized_nomination_level = SD_LV_NONE;

