Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbZDUMSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbZDUMSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 08:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZDUMS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 08:18:28 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:34580 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750832AbZDUMS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 08:18:28 -0400
Date: Tue, 21 Apr 2009 21:18:27 +0900 (JST)
Message-Id: <20090421.211827.39163016.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: nauman@google.com, fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org,
       jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com,
       agk@redhat.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com
Subject: Re: [dm-devel] Re: dm-ioband: Test results.
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090420213738.GB9080@redhat.com>
References: <e98e18940904161324p9833457vdf699d66bb323591@mail.gmail.com>
	<20090420.172959.193682665.ryov@valinux.co.jp>
	<20090420213738.GB9080@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

> > I could see the priority inversion by running Vivek's script and I
> > understand how RT requests has to be handled. I'll create a patch
> > which makes dm-ioband cooperates with CFQ scheduler. However, do you
> > think we need some kind of limitation on processes which belong to the
> > RT class to prevent the processes from depleting bandwidth?
>
> I think to begin with, we can keep the same behavior as CFQ. An RT task
> can starve other tasks.
> 
> But we should provide two configurations and user can choose any one.
> If RT task is in root group, it will starve other sibling tasks/groups. If
> it is with-in a cgroup, then it will starve its sibling only with-in that
> cgroup and will not impact other cgroups.
> 
> What I mean is following.
> 
> 			root
> 			/  \
> 		      RT   group1
> 
> In above configuration RT task will starve everybody else.
> 
> 			root
> 		        /   \
> 		   group1   group2
> 		   /  \
> 	         RT   BE
> 
> In above configuration  RT task will starve only sibling in group1 but
> will not starve the tasks in group2 or in root.

Thanks for the suggestion. I'll try this way when dm-ioband supports
hierarchical grouping.

Thanks,
Ryo Tsuruta
