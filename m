Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbXFNTKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbXFNTKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbXFNTKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:10:09 -0400
Received: from main.gmane.org ([80.91.229.2]:47002 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbXFNTKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:10:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: [patch] sched: fix SysRq-N (normalize RT tasks)
Date: Thu, 14 Jun 2007 20:09:46 +0100
Message-ID: <yw1xfy4utksl.fsf@thrashbarg.mansr.com>
References: <20070614094830.GA494@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: agrajag.inprovide.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (Double Solitaire, linux)
Cancel-Lock: sha1:+hh0neM0fkJ9KasZN3QK7pFS1cA=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: [patch] sched: fix SysRq-N (normalize RT tasks)
>
> Gene Heskett reported the following problem while testing CFS: SysRq-N 
> is not always effective in normalizing tasks back to SCHED_OTHER.
>
> the reason for that turns out to be the following bug: 
> normalize_rt_tasks() uses for_each_process() to iterate through all 
> tasks in the system. The problem is, this method does not iterate 
> through all tasks, it iterates through all thread groups. The proper 
> mechanism to enumerate all tasks is to use a do_each_thread() + 
> while_each_thread() loop.

Was this always a bug or did the meaning of for_each_process() change
since this code was added?

-- 
Måns Rullgård
mans@mansr.com

