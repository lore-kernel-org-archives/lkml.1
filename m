Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbXCYE5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbXCYE5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 00:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933082AbXCYE5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 00:57:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59471 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbXCYE5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 00:57:47 -0400
Date: Sun, 25 Mar 2007 10:35:07 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, ebiederm@xmission.com, mbligh@google.com,
       winget@google.com, containers@lists.osdl.org, serue@us.ibm.com,
       menage@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070325050507.GG11794@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com> <20070324150505.GB9475@in.ibm.com> <20070324122559.11b9ba34.pj@sgi.com> <20070325004529.GD11794@in.ibm.com> <20070324184128.e8b34a3e.pj@sgi.com> <20070325022816.GE11794@in.ibm.com> <20070324214550.d6e654bf.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070324214550.d6e654bf.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2007 at 09:45:50PM -0700, Paul Jackson wrote:
> Nice work - thanks.  Yes, both an extra cpuset count and a negative
> cpuset count are bad news, opening the door to the usual catastrophes.
> 
> Would you like the honor of submitting the patch to add a task_lock
> to cpuset_exit()?  If you do, be sure to fix, or at least remove,
> the cpuset_exit comment lines:

I will try to send out a patch later today to fix this bug in mainline
cpuset code. I happened to notice this race with my rcfs patch and observed 
same is true with cpuset/container code also.

>  * We don't need to task_lock() this reference to tsk->cpuset,
>  * because tsk is already marked PF_EXITING, so attach_task() won't
>  * mess with it, or task is a failed fork, never visible to attach_task.

Sure, I had seen that.

> So, in real life, this would be a difficult race to trigger.

Agreed, but good to keep code clean isn't it? :)

> Thanks for finding this.

Wellcome!

-- 
Regards,
vatsa
