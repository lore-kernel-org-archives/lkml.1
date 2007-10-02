Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbXJBNdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbXJBNdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXJBNdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:33:43 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:59583 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbXJBNdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:33:42 -0400
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 14/15](repost) LSM expansion for TOMOYO Linux.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <4701F285.5000206@nttdata.co.jp>
	<4701F5CC.7040209@nttdata.co.jp>
	<Xine.LNX.4.64.0710020546260.21841@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0710020546260.21841@us.intercode.com.au>
Message-Id: <200710022233.ICD81749.LJFFHOtOSVOFQM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 2 Oct 2007 22:33:40 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

James Morris wrote:
> Why do you need racy unlocked versions, in addition to the existing 
> security_task_kill() hook which is called safely via 
> check_kill_permission() ?

TOMOYO Linux provides "delayed enforcing mode" which allows administrator
judge interactively for requests that violated policy.

Sometimes, especially after updating software packages, irregular behavior arise.
So, the administrator prepares for such irregular behavior
by invoking "ccs-queryd" userland program.
The "ccs-queryd" prints the contents of policy violation and
asks the administrator whether to grant the request that violated policy.
This can reduce the possibility of "restarting process failed due to permission denied".

Thus, security_task_kill() which is called with tasklist_lock held
is not what TOMOYO Linux wants.

I know this approach is racy, but TOMOYO Linux wants these unlocked versions
to avoid failure due to permission denial caused by MAC's policy.

Regards.

