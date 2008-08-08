Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYHHIay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYHHIay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 04:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYHHIaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 04:30:46 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:45062 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753401AbYHHIap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 04:30:45 -0400
Date: Fri, 08 Aug 2008 17:30:45 +0900 (JST)
Message-Id: <20080808.173045.112614776.ryov@valinux.co.jp>
To: yoshikawa.takuya@oss.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org
Subject: Re: [PATCH 6/7] bio-cgroup: Implement the bio-cgroup
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <489BF14D.6050009@oss.ntt.co.jp>
References: <20080804.175934.112619046.ryov@valinux.co.jp>
	<20080804.180022.183027902.ryov@valinux.co.jp>
	<489BF14D.6050009@oss.ntt.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoshikawa-san,

> > +static void bio_cgroup_move_task(struct cgroup_subsys *ss,
> > +				struct cgroup *cont,
> > +				struct cgroup *old_cont,
> > +				struct task_struct *p)
> > +{
> > +	struct mm_struct *mm;
> > +	struct bio_cgroup *biog, *old_biog;
> > +
> > +	if (bio_cgroup_disabled())
> > +		return;
> > +
> > +	mm = get_task_mm(p);
> > +	if (mm == NULL)
> > +		return;
> > +
> > +	biog = cgroup_bio(cont);
> > +	old_biog = cgroup_bio(old_cont);
> > +
> > +	mmput(mm);
> > +	return;
> > +}
> 
> Is this function fully implemented?

This function can be more simplified, there is some unnecessary code 
from old version.

> I tried to put a process into a group by writing to
> "/cgroup/bio/BGROUP/tasks" but failed.

Could you tell me what you actually did? I will try the same thing.

--
Ryo Tsuruta <ryov@valinux.co.jp>
