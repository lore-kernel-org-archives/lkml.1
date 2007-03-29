Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbXC2LiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbXC2LiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 07:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbXC2LiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 07:38:10 -0400
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:40842 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338AbXC2LiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 07:38:09 -0400
Message-ID: <460BA513.6010908@blueyonder.co.uk>
Date: Thu, 29 Mar 2007 12:37:55 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Adrian Bunk <bunk@stusta.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, auxsvr@gmail.com
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45E59D64.3070202@blueyonder.co.uk>	<200702281805.13822.auxsvr@gmail.com>	<20070307214730.87859590.akpm@linux-foundation.org>	<45EFBC73.2030005@blueyonder.co.uk>	<46016EAF.6010801@blueyonder.co.uk> <20070321193420.GP752@stusta.de>	<m17itabbbv.fsf@ebiederm.dsl.xmission.com>	<4601DCB4.4060804@blueyonder.co.uk>	<20070321184258.758a5a29.randy.dunlap@oracle.com>	<20070322105908.GS752@stusta.de> <4608919C.4050007@blueyonder.co.uk>	<m1y7liyeyt.fsf@ebiederm.dsl.xmission.com>	<4609E04D.408@blueyonder.co.uk> <m1r6r8n1a7.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6r8n1a7.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Sid I think I have found the problem. Could you try the following patch. 
> I believe I accidentally switched the sense of a test....
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index f132349..b55ed4c 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -790,7 +790,7 @@ static void exit_notify(struct task_struct *tsk)
>  	
>  	pgrp = task_pgrp(tsk);
>  	if ((task_pgrp(t) != pgrp) &&
> -	    (task_session(t) != task_session(tsk)) &&
> +	    (task_session(t) == task_session(tsk)) &&
>  	    will_become_orphaned_pgrp(pgrp, tsk) &&
>  	    has_stopped_jobs(pgrp)) {
>  		__kill_pgrp_info(SIGHUP, SEND_SIG_PRIV, pgrp);
>
>
>
>
>   
AOK I shall apply to 2.6.21-rc5-git4 and test.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


