Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZHQG3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZHQG3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 02:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZHQG3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 02:29:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:6406 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZHQG3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 02:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q/OhKSeAOvcDEca+G9DwxSG+BjuDXidezEi5eU0qXqKW7OtonhOwI6isJF/2s5fQFz
         gdK58qEW7ZVNtNOzlW8XWF46hHAfX6g9tqw2ddqhPPbmBUN9WLuEEHTEcT0CCMomic8M
         gkCEtzs/GHgzqQfXjQpu6U1iNYniGtsB0EZLw=
Date: Mon, 17 Aug 2009 14:32:02 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Tatsuhiro Aoshima <tatsu.pc@gmail.com>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] proc: let task status file print utime and stime.
Message-ID: <20090817063202.GO5039@cr0.nay.redhat.com>
References: <20090815233629.A067.A69D9226@jp.fujitsu.com> <20090817023802.GF5039@cr0.nay.redhat.com> <20090817114242.1419bd1f.kamezawa.hiroyu@jp.fujitsu.com> <20090817061821.GM5039@cr0.nay.redhat.com> <20090817152206.50c35330.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817152206.50c35330.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 03:22:06PM +0900, KAMEZAWA Hiroyuki wrote:
>On Mon, 17 Aug 2009 14:18:21 +0800
>Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> Ah... in fact, I expected 'ps' can report this, however, surprisingly
>> it doesn't have this, at least not what I expect (unless I miss
>> something obvious).
>> 
>> 
>> >
>> >In another thinking, in old days, /proc/<pid>/stat was enough because most of
>> >users uses scanf() or some C langage to read fixed-format data.
>> >/proc/<pid>/status is useful for some script languages which has 
>> >good parser per line. 
>> >
>> 
>> Well... I think this work should be left to 'ps', e.g.
>> 
>>   ps -o pid,utime,stime
>> 
>> 'ps' is responsible to read /proc/<pid>/stat for the user.
>> 
>Hmm, personally, I don't like 'ps' and its unified filter.
>
>When I want to know status of a process of PID,
># ps -o pid,utime,stime  PID
>
>'ps' scans *all* process and filter PID. (try #strace ps)
>I like checking /proc/<pid>/<something> without 'ps' in an environment
>where thousands of processes runs.

Sure, we already have '-p' for 'ps', e.g.

 ps -p 1 -o pid,user,comm

Enjoy. :-)

Anyway, I would like to see 'ps' to have 'utime,stime' field, on
my machine, its output for 'utime,stime' looks wrong.

Maybe we should Cc procps developers?
