Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbXKLLm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbXKLLm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 06:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbXKLLms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 06:42:48 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:60520 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023AbXKLLms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 06:42:48 -0500
To: ebiederm@xmission.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Check length at deprecated_sysctl_warning.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200711080257.lA82vQfA015942@www262.sakura.ne.jp>
	<20071107192211.c1c22e97.akpm@linux-foundation.org>
	<200711080819.lA88J8Pv072259@www262.sakura.ne.jp>
	<m14pfr6bnf.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14pfr6bnf.fsf@ebiederm.dsl.xmission.com>
Message-Id: <200711122042.HDC69753.LMOOVJFOQHFtFS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 12 Nov 2007 20:42:41 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Eric W. Biederman wrote:
> name[CTL_MAXNAME} is not valid.
> name[0...CTL_MAXNAME-1] is valid.
Yes.

> The check that got lost in the refactoring was specfically:
> 
> -       if (tmp.nlen <= 0 || tmp.nlen >= CTL_MAXNAME)
> -               return -ENOTDIR;
Thus I think tmp.nlen == CTL_MAXNAME should be allowed
because tmp.nlen is used as "for (i = 0; i < tmp.nlen; i++)".
I think
	if (tmp.nlen <= 0 || tmp.nlen > CTL_MAXNAME)
		return -ENOTDIR;
is correct.

Thanks.

