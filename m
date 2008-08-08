Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYHHHmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYHHHmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 03:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYHHHmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 03:42:23 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60525 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbYHHHmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 03:42:23 -0400
X-Greylist: delayed 2015 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2008 03:42:22 EDT
Message-ID: <489BF14D.6050009@oss.ntt.co.jp>
Date: Fri, 08 Aug 2008 16:10:05 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
CC: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org
Subject: Re: [PATCH 6/7] bio-cgroup: Implement the bio-cgroup
References: <20080804.175707.104036289.ryov@valinux.co.jp>	<20080804.175748.189722512.ryov@valinux.co.jp>	<20080804.175934.112619046.ryov@valinux.co.jp> <20080804.180022.183027902.ryov@valinux.co.jp>
In-Reply-To: <20080804.180022.183027902.ryov@valinux.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryo Tsuruta wrote:
> +static void bio_cgroup_move_task(struct cgroup_subsys *ss,
> +				struct cgroup *cont,
> +				struct cgroup *old_cont,
> +				struct task_struct *p)
> +{
> +	struct mm_struct *mm;
> +	struct bio_cgroup *biog, *old_biog;
> +
> +	if (bio_cgroup_disabled())
> +		return;
> +
> +	mm = get_task_mm(p);
> +	if (mm == NULL)
> +		return;
> +
> +	biog = cgroup_bio(cont);
> +	old_biog = cgroup_bio(old_cont);
> +
> +	mmput(mm);
> +	return;
> +}

Is this function fully implemented?
I tried to put a process into a group by writing to 
"/cgroup/bio/BGROUP/tasks" but failed.

I think this function is not enough to be used as "attach."

> +
> +
> +struct cgroup_subsys bio_cgroup_subsys = {
> +	.name           = "bio",
> +	.subsys_id      = bio_cgroup_subsys_id,
> +	.create         = bio_cgroup_create,
> +	.destroy        = bio_cgroup_destroy,
> +	.pre_destroy	= bio_cgroup_pre_destroy,
> +	.populate       = bio_cgroup_populate,
> +	.attach		= bio_cgroup_move_task,
> +	.early_init	= 0,
> +};

Without "attach" function, it is difficult to check
the effectiveness of block I/O tracking.

Thanks,
- Takuya Yoshikawa
