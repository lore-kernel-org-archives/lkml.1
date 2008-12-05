Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbYLEX2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbYLEX2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 18:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbYLEX1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 18:27:52 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:58048 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbYLEX1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 18:27:51 -0500
To: sds@tycho.nsa.gov, viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: serue@us.ibm.com, jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [PATCH (mmotm-2008-12-02-17-08)] Introduce security_path_set/clear() hooks.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <49364808.1070907@nttdata.co.jp>
	<493649C5.2060402@nttdata.co.jp>
	<1228313605.32059.23.camel@moss-spartans.epoch.ncsc.mil>
	<200812042100.HFE00081.tFFOHMQVOLFOSJ@I-love.SAKURA.ne.jp>
	<1228513998.21715.75.camel@localhost.localdomain>
In-Reply-To: <1228513998.21715.75.camel@localhost.localdomain>
Message-Id: <200812060827.ECD30776.FLOOHVFMtSOFJQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 6 Dec 2008 08:27:45 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Stephen Smalley wrote:
> > Right. Locations of inserting security_path_set()/security_path_clear() pairs
> > are subset of mnt_want_write()/mnt_drop_write() pairs. Thus, we can insert
> > security_path_set()/security_path_clear() pairs into
> > mnt_want_write()/mnt_drop_write() pairs, if we can tolerate performance
> > regression. According to our rough measurement, there is about 8 - 22% of
> > performance regression. But this approach needs minimum modification to the
> > existing kernel (only two hooks to be inserted).
> 
> I assume you also need separate hooks to cover the read-only open case?

security_dentry_open() receives "struct file *", so I think we don't need
separate hooks for open(O_RDONLY).

> As for your performance, your implementation of mp_* is clearly
> non-optimal, so I'd expect there is plenty of room for improvement
> there.

Yes. Thus, I want to pass a caller identifier to mnt_want_write() so that
we can skip calculating vfsmount's pathname when it is not interested for
a LSM module (e.g. mnt_want_write() called for updating atime/ctime/mtime
checks).
May I add "int caller_id" to mnt_want_write()?

> No #ifdef's within the functions, of course.  That gets handled by
> security.h.
OK.

Regards.
