Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbYA0Ocz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbYA0Ocz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 09:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYA0Ocs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 09:32:48 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34958 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYA0Ocr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 09:32:47 -0500
Date: Sun, 27 Jan 2008 20:16:10 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Toralf.=?iso-8859-1?Q?F=F6rster_=3Ctoralf=2Efoerster=40gmx=2Ede=3E?=@snowy.in.ibm.com
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Message-ID: <20080127144610.GA25632@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <479B69D2.5050603@wpkg.org> <200801261946.54518.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801261946.54518.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 07:46:51PM +0100, Toralf Förster wrote:
> 
> The problem is the same as described here : http://lkml.org/lkml/2007/10/21/85
> If I run dnetc even with lowest prority than the CPU stays at 600 MHz regardless
> of any other load (eg. rsyncing, svn update, compiling, ...)
> 
> Stopping the dnetc process immediately speeds up the CPU up to 1.7 GHz.
> 
> 
> Am Samstag, 26. Januar 2008 schrieben Sie:
> > During the test, run top, and watch your CPU usage. Does it go above 80% 
> > (the default for 
> > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold).
> 
> No, instead I get :
> 
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  7294 dnetc     39  19   664  348  264 R 49.5  0.0   0:48.68 dnetc
>  7310 tfoerste  20   0  1796  492  428 R 48.5  0.0   0:07.19 factor
>  7050 root      20   0 96736 8872 3972 S  0.7  0.9   0:02.99 X

Hi Toralf,
	Can you list the o/p you see for overall cpu usage? You should
see something like below right at the top of the o/p:

top - 20:03:59 up 12 days, 21:39, 18 users,  load average: 0.22, 0.20, 0.25
Tasks: 200 total,   5 running, 193 sleeping,   0 stopped,   2 zombie
Cpu(s):  2.6% us,  1.3% sy,  0.0% ni, 96.0% id,  0.0% wa,  0.0% hi, 0.0% si,  0.0% st

The third line (giving overall cpu usage stats) is what is interesting here.
If you have more than one cpu, you can get cpu usage stats for each cpu
in top by pressing 1. Can you provide this information with and w/o 
CONFIG_FAIR_GROUP_SCHED?

If I am not mistaken, cpu ondemand gov goes by the cpu idle time stats,
which should not be affected by FAIR_GROUP_SCHED. I will lookaround for
other possible causes.

-- 
Regards,
vatsa
