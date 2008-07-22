Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbYGVPqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbYGVPqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 11:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYGVPqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 11:46:04 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:61147 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYGVPqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 11:46:02 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC] Add a counter in task_struct for skipping permission check. (Was: Should LSM hooks be called by filesystem's requests?) 
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200807221959.HDJ90154.FFLMOtVOOQJFSH@I-love.SAKURA.ne.jp>
References: <200807142020.BCC17654.SMtQFVFOFOHOJL@I-love.SAKURA.ne.jp> <487C22A2.9090402@schaufler-ca.com> <200807221959.HDJ90154.FFLMOtVOOQJFSH@I-love.SAKURA.ne.jp>
Date: Wed, 23 Jul 2008 00:46:00 +0900
Message-ID: <8047.1216741560@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tetsuo Handa:
> I have a problem with unionfs and LSM.
> The unionfs causes NULL pointer dereference if copyup_dentry()
> failed by LSM's decision, so I'm searching for a solution.
	:::
> I think this patch can disable LSM checks if vfs_*() and
> notify_change() is called by unionfs's internal operations.
> This patch is just an idea, not tested at all.
> 
> Does somebody have a solution?

How about 'delegate' feature in AUFS?

(from the aufs manual)
If you do not want your application to access branches through aufs or
to be traced strictly by task I/O accounting, you can
use the kernel threads in aufs. If you enable CONFIG_AUFS_DLGT and
specify `dlgt' mount option, then
aufs delegates its internal
access to the branches to the kernel threads.

When you define CONFIG_SECURITY and use any type of Linux Security Module
(LSM), for example SUSE AppArmor, you may meet some errors or
warnings from your security module. Because aufs access its branches
internally, your security module may detect, report, or prohibit it.
The behaviour is highly depending upon your security module and its
configuration.
In this case, you can use `dlgt' mount option, too.
Your LSM will see the
aufs kernel threads access to the branch, instead of your
application.


Junjiro Okajima
