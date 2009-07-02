Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZGBJ0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZGBJ0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZGBJ0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:26:00 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:64687 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZGBJZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:25:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ixoWNkPkFha6qXkd1ZqMOeQnU1BrsNJr1kPRLMHHKYEDboFAx10sK7+vMZoiBTeetP
         OX7Wjc5CtcdfmzY5b2ycan0k7nX/NWUjX8CG6kWJxOzRdJ2hgsaszCzI45VDhQJhXI//
         AhmmATQvQUPB6dikMX1D5ZfpgiasOc0mKOR8Q=
Date: Thu, 2 Jul 2009 17:28:07 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, ebiederm@xmission.com,
       tao.ma@oracle.com, linux-kernel@vger.kernel.org, adobriyan@gmail.com,
       mtk.manpages@gmail.com
Subject: Re: [RESEND Patch] kcore: remove its pointless size
Message-ID: <20090702092807.GC6372@cr0.nay.redhat.com>
References: <m17hzdhkr8.fsf@fess.ebiederm.org> <2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com> <m1my88568n.fsf@fess.ebiederm.org> <20090618030051.GA6133@cr0.nay.redhat.com> <m1tz2ei54r.fsf@fess.ebiederm.org> <20090618044055.GB6133@cr0.nay.redhat.com> <m1prd2rtdf.fsf@fess.ebiederm.org> <20090622085405.GA6499@cr0.nay.redhat.com> <20090630100850.GD5873@cr0.nay.redhat.com> <20090701144742.6ce3535b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701144742.6ce3535b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 02:47:42PM -0700, Andrew Morton wrote:
>On Tue, 30 Jun 2009 18:08:50 +0800
>Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> 
>> Linus fixes wrong size of /proc/kcore problem in commit 9063c61fd5cbd.
>> 
>> But its size still looks insane, since it never equals to the size
>> of physical memory.
>
>Better changelogs, please!
>
>I think that what you're saying is that the stat.st_size field of the
>/proc/kcore inode does not equal the amount of physical memory, and
>that you think it should do so?


No, it is expected to be more than the amount of physical memory.


>
>If that is correct then it would be appropriate to explain what value
>the stat.st_size field has before the patch and afterwards.  Just
>calling it "insane" isn't optimal.

Yup!

My bad, I just mentioned this in the earlier email in this thread,
but I forgot it put it here. Sorry for this!

>
>AFAICT this means that proc_root_kcore->size will remain uninitialised
>until a process opens and reads from /proc/kcore.  So on initial boot
>the `ls' output will presumably show a size of zero, and this will
>change once /proc/kcore has been read?

Yes, exactly...

>
>If so, should we run get_kcore_size() in proc_kcore_init(), perhaps?

Yes, we can, but I think leaving this like what the rest /proc files
behave is better.

>
>In fact, do we need to run get_kcore_size() more than once per boot? 
>AFAICT we only run kclist_add() during bootup, so if proc_kcore_init()
>is called at the appropriate time, we can permanently cache its result?
>
>In which case get_kcore_size() and kclist_add() can be marked __init.

A quick grep shows kclist_add() can be marked as __init, but I don't
know if anyone will use it in other parts in the future.

I prefer leaving it as it is.
