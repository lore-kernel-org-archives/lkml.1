Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbZHQGem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbZHQGem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 02:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbZHQGel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 02:34:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45871 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZHQGel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 02:34:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 17 Aug 2009 15:32:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Tatsuhiro Aoshima <tatsu.pc@gmail.com>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] proc: let task status file print utime and stime.
Message-Id: <20090817153253.52bf9c69.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090817063202.GO5039@cr0.nay.redhat.com>
References: <20090815233629.A067.A69D9226@jp.fujitsu.com>
	<20090817023802.GF5039@cr0.nay.redhat.com>
	<20090817114242.1419bd1f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090817061821.GM5039@cr0.nay.redhat.com>
	<20090817152206.50c35330.kamezawa.hiroyu@jp.fujitsu.com>
	<20090817063202.GO5039@cr0.nay.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 14:32:02 +0800
Amerigo Wang <xiyou.wangcong@gmail.com> wrote:

> On Mon, Aug 17, 2009 at 03:22:06PM +0900, KAMEZAWA Hiroyuki wrote:
> >On Mon, 17 Aug 2009 14:18:21 +0800
> >Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
> >
> >> Ah... in fact, I expected 'ps' can report this, however, surprisingly
> >> it doesn't have this, at least not what I expect (unless I miss
> >> something obvious).
> >> 
> >> 
> >> >
> >> >In another thinking, in old days, /proc/<pid>/stat was enough because most of
> >> >users uses scanf() or some C langage to read fixed-format data.
> >> >/proc/<pid>/status is useful for some script languages which has 
> >> >good parser per line. 
> >> >
> >> 
> >> Well... I think this work should be left to 'ps', e.g.
> >> 
> >>   ps -o pid,utime,stime
> >> 
> >> 'ps' is responsible to read /proc/<pid>/stat for the user.
> >> 
> >Hmm, personally, I don't like 'ps' and its unified filter.
> >
> >When I want to know status of a process of PID,
> ># ps -o pid,utime,stime  PID
> >
> >'ps' scans *all* process and filter PID. (try #strace ps)
> >I like checking /proc/<pid>/<something> without 'ps' in an environment
> >where thousands of processes runs.
> 
> Sure, we already have '-p' for 'ps', e.g.
> 
>  ps -p 1 -o pid,user,comm
> 
> Enjoy. :-)
I said it's verrrrry slow.

> 
> Anyway, I would like to see 'ps' to have 'utime,stime' field, on
> my machine, its output for 'utime,stime' looks wrong.
> 
> Maybe we should Cc procps developers?
ya, maybe. it's good to be CCed.


BTW, why all other status
Name:   cat
State:  R (running)
Tgid:   7068
Pid:    7068
PPid:   6115
TracerPid:      0
Uid:    500     500     500     500
Gid:    500     500     500     500
FDSize: 256
Groups: 500

are allowed to be duplicated ?

I bet stime.utime will be used more often than TracerPid/FDSize/ ;)

Thanks,
-Kame


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

