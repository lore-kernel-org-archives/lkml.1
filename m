Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZHQGQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZHQGQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 02:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbZHQGQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 02:16:14 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:59461 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZHQGQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 02:16:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cyBPRSfEfzavXI3VdDm9Qr3FYSP0LH6FeAf7BMCocp20FPBZTrU9yne7iVPczYZBqj
         oHSuHDq4TytZSi8fT1YiQWcb0bZFKh/pKyURL025XfK3A+InnMKLBzPTprhXdHwKrimn
         dXW6OUR+hHez7Pkvw/JKro2OaqhspABn3npcY=
Date: Mon, 17 Aug 2009 14:18:21 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Tatsuhiro Aoshima <tatsu.pc@gmail.com>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] proc: let task status file print utime and stime.
Message-ID: <20090817061821.GM5039@cr0.nay.redhat.com>
References: <20090815233629.A067.A69D9226@jp.fujitsu.com> <20090817023802.GF5039@cr0.nay.redhat.com> <20090817114242.1419bd1f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817114242.1419bd1f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 11:42:42AM +0900, KAMEZAWA Hiroyuki wrote:
>On Mon, 17 Aug 2009 10:38:02 +0800
>Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> On Sat, Aug 15, 2009 at 11:36:41PM +0900, KOSAKI Motohiro wrote:
>> >From: Tatsuhiro Aoshima <tatsu.pc@gmail.com>
>> >Subject: [PATCH] proc: let task status file print utime and stime.
>> >
>> >The task status file in proc file system did not contain
>> >user-time and system-time. Thus, users could not get
>> >those information of running task easily. I think
>> >these values should be provived in human readable format.
>> >By this patch, users can get stime and utime very easily.
>> 
>> 
>> Why? /proc/<pid>/stat already has these.
>> 
>
>I wonder /proc/<pid>/stat is unreadable for usual human.
>Most of ents in /proc/<pid>/status is duplicated output of 
>some other files(i.e. /proc/<pid>/stat) and /proc/<pid>/status is
>for human readble format.


Ah... in fact, I expected 'ps' can report this, however, surprisingly
it doesn't have this, at least not what I expect (unless I miss
something obvious).


>
>In another thinking, in old days, /proc/<pid>/stat was enough because most of
>users uses scanf() or some C langage to read fixed-format data.
>/proc/<pid>/status is useful for some script languages which has 
>good parser per line. 
>

Well... I think this work should be left to 'ps', e.g.

  ps -o pid,utime,stime

'ps' is responsible to read /proc/<pid>/stat for the user.

Thanks.
