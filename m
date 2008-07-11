Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbYGKDwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbYGKDwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 23:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYGKDwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 23:52:03 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53861 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYGKDwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 23:52:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
       andi@firstfloor.org, jbarnes@virtuousgeek.org, steiner@sgi.com,
       linux-kernel@vger.kernel.org
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<20080710182238.631011000@linux-os.sc.intel.com>
	<m1mykpfh56.fsf@frodo.ebiederm.org> <4876C572.3070803@sgi.com>
Date: Thu, 10 Jul 2008 20:50:40 -0700
In-Reply-To: <4876C572.3070803@sgi.com> (Mike Travis's message of "Thu, 10 Jul
	2008 19:29:06 -0700")
Message-ID: <m1k5ftaxkf.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1652]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 19/26] x64, x2apic/intr-remap: introcude self IPI to genapic routines
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:
>
> On a similar subject I would really like to change the send_IPI_mask to pass a
> pointer to the cpumask_t arg:
>
>         void (*send_IPI_mask)(cpumask_t mask, int vector);
>
>
> This bloats the stack by 512 bytes and seemingly is called by some fairly
> nested routines.  Any opinions?

It sounds like a pain.  Especially since we would need to dereference
cpumask_t when we use it.  Does any remember if there was a plan for
dealing with cpumask_t when the number of cpus got large?

If we pass in a pointer to constant data semantically we should be fine.

Mostly I am wondering if three isn't a cleaner solution hidden away somewhere.

Eric

