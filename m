Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbYAPHdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbYAPHdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 02:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYAPHdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 02:33:09 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46538 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbYAPHdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 02:33:08 -0500
Date: Wed, 16 Jan 2008 16:33:12 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Clifford Wolf <clifford@clifford.at>
Subject: Re: [PATCH] rlim in proc/<pid>/status (2nd rev.)
Cc: kosaki.motohiro@jp.fujitsu.com, serge@hallyn.com,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080116070346.GA24106@clifford.at>
References: <20080115203659.GA5404@vino.hallyn.com> <20080116070346.GA24106@clifford.at>
Message-Id: <20080116163045.11C8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clifford,

> +static inline char *task_rlim(struct task_struct *p, char *buffer)
> +{
> +	unsigned long flags;
> +	struct rlimit rlim[RLIM_NLIMITS];
> +	int i;
> +	
> +	rcu_read_lock();
> +	if (lock_task_sighand(p, &flags)) {
> +		for (i=0; i<RLIM_NLIMITS; i++)
> +			rlim[i] = p->signal->rlim[i];
> +		unlock_task_sighand(p, &flags);
> +	}

lock_task_sighand is possible return NULL?
if so, rlim is uninitialized when NULL.


- kosaki


