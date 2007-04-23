Return-Path: <linux-kernel-owner+w=401wt.eu-S1751076AbXDWNSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbXDWNSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXDWNSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:18:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39107 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbXDWNSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:18:48 -0400
Date: Mon, 23 Apr 2007 18:47:20 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Message-ID: <20070423131720.GE25144@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070419120131.GB13435@in.ibm.com> <20070420183118.GA695@elte.hu> <200704222128.49419.rjw@sisk.pl> <200704222139.27128.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704222139.27128.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 09:39:26PM +0200, Rafael J. Wysocki wrote:
> @@ -63,9 +100,9 @@ static inline int thaw_process(struct ta
>   */
>  static inline void frozen_process(struct task_struct *p)
>  {
> -	p->flags |= PF_FROZEN;
> +	set_frozen_flag(p);
>  	wmb();
> -	clear_tsk_thread_flag(p, TIF_FREEZE);
> +	do_not_freeze(p);

We may want to rename do_not_freeze to something else. It kind of
looks weird calling do_not_freeze(p) after setting the frozen flag!

Probably, just a matter of taste :-)

>  }
> 

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
