Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZHQIbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZHQIbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbZHQIbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:31:50 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:63165 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbZHQIbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:31:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uQJtv4+iyfZChQBrvgSb9wbq3OotV6MYSrofst6pkK5SJwsgJ7s222nt55Whf8WEN2
         TcwHz/HF6GndtErOEBCnLNwsV4LK2ItnPtKekIdjYup3HiOE1H+aSJSGybRQ1q6kvzdM
         RWjHCZpfUTg5XkFiIZLmoh0fG+ME6+PqrIAYM=
Date: Mon, 17 Aug 2009 16:34:04 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Tatsuhiro Aoshima <tatsu.pc@gmail.com>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>, albert@users.sf.net
Subject: Re: [PATCH] proc: let task status file print utime and stime.
Message-ID: <20090817083404.GC5868@cr0.nay.redhat.com>
References: <20090815233629.A067.A69D9226@jp.fujitsu.com> <20090817023802.GF5039@cr0.nay.redhat.com> <20090817114242.1419bd1f.kamezawa.hiroyu@jp.fujitsu.com> <20090817061821.GM5039@cr0.nay.redhat.com> <20090817152206.50c35330.kamezawa.hiroyu@jp.fujitsu.com> <20090817063202.GO5039@cr0.nay.redhat.com> <20090817153253.52bf9c69.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817153253.52bf9c69.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 03:32:53PM +0900, KAMEZAWA Hiroyuki wrote:
>On Mon, 17 Aug 2009 14:32:02 +0800
>Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> On Mon, Aug 17, 2009 at 03:22:06PM +0900, KAMEZAWA Hiroyuki wrote:
>> >On Mon, 17 Aug 2009 14:18:21 +0800
>> >Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
>> >
>> >> Ah... in fact, I expected 'ps' can report this, however, surprisingly
>> >> it doesn't have this, at least not what I expect (unless I miss
>> >> something obvious).
>> >> 
>> >> 
>> >> >
>> >> >In another thinking, in old days, /proc/<pid>/stat was enough because most of
>> >> >users uses scanf() or some C langage to read fixed-format data.
>> >> >/proc/<pid>/status is useful for some script languages which has 
>> >> >good parser per line. 
>> >> >
>> >> 
>> >> Well... I think this work should be left to 'ps', e.g.
>> >> 
>> >>   ps -o pid,utime,stime
>> >> 
>> >> 'ps' is responsible to read /proc/<pid>/stat for the user.
>> >> 
>> >Hmm, personally, I don't like 'ps' and its unified filter.
>> >
>> >When I want to know status of a process of PID,
>> ># ps -o pid,utime,stime  PID
>> >
>> >'ps' scans *all* process and filter PID. (try #strace ps)
>> >I like checking /proc/<pid>/<something> without 'ps' in an environment
>> >where thousands of processes runs.
>> 
>> Sure, we already have '-p' for 'ps', e.g.
>> 
>>  ps -p 1 -o pid,user,comm
>> 
>> Enjoy. :-)
>I said it's verrrrry slow.


Hmm, for me it looks like that 'ps' should be fixed...

I haven't checked the source code of 'ps', but I don't think
this is O(n) if '-p' is specified. If we just use something
like 'test -d /proc/<pid>' it would be O(1).


>
>> 
>> Anyway, I would like to see 'ps' to have 'utime,stime' field, on
>> my machine, its output for 'utime,stime' looks wrong.
>> 
>> Maybe we should Cc procps developers?
>ya, maybe. it's good to be CCed.


Done. Albert?


>
>
>BTW, why all other status
>Name:   cat
>State:  R (running)
>Tgid:   7068
>Pid:    7068
>PPid:   6115
>TracerPid:      0
>Uid:    500     500     500     500
>Gid:    500     500     500     500
>FDSize: 256
>Groups: 500
>
>are allowed to be duplicated ?


I don't know... :( I still prefer to use 'ps'.
