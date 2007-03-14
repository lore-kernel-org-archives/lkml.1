Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbXCNBJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbXCNBJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 21:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbXCNBJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 21:09:46 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:6146 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbXCNBJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 21:09:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dVs8HxPXO6YM7liby/VMi/TmYoRLBfmh6WNAtltET4IfaGThM4/0Jm9Q3LZw6nia61gIjXI8zSEW6b2K33UGGqh1yHAy1z/q/pEjWZyztQmFLbq710x4i9pKOb6cYFDcx042XguZXk161eDB78uj0xVbFwVbtBhBHbJEUhHIXX8=
Message-ID: <29495f1d0703131809i6f76e409q2c505a33f0b23a8d@mail.gmail.com>
Date: Tue, 13 Mar 2007 18:09:42 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: SMP performance degradation with sysbench
Cc: "Anton Blanchard" <anton@samba.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Rik van Riel" <riel@redhat.com>,
       "Lorenzo Allegrucci" <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <45F74917.40806@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1172425476.5489.11.camel@odyssey.lan>
	 <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au>
	 <20070312220042.GA807@kryten>
	 <29495f1d0703131736l74a63c15n94f03527d7e63500@mail.gmail.com>
	 <45F74917.40806@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Nish Aravamudan a écrit :
> > On 3/12/07, Anton Blanchard <anton@samba.org> wrote:
> >>
> >> Hi Nick,
> >>
> >> > Anyway, I'll keep experimenting. If anyone from MySQL wants to help
> >> look
> >> > at this, send me a mail (eg. especially with the sched_setscheduler
> >> issue,
> >> > you might be able to do something better).
> >>
> >> I took a look at this today and figured Id document it:
> >>
> >> http://ozlabs.org/~anton/linux/sysbench/
> >>
> >> Bottom line: it looks like issues in the glibc malloc library, replacing
> >> it with the google malloc library fixes the negative scaling:
> >>
> >> # apt-get install libgoogle-perftools0
> >> # LD_PRELOAD=/usr/lib/libtcmalloc.so /usr/sbin/mysqld
> >
> > Quick datapoint, still collecting data and trying to verify it's
> > always the case: on my 8-way Xeon, I'm actually seeing *much* worse
> > performance with libtcmalloc.so compared to mainline. Am generating
> > graphs and such still, but maybe someone else with x86_64 hardware
> > could try the google PRELOAD and see if it helps/hurts (to rule out
> > tester stupidity)?
>
> I wish I had a 8-way test platform :)
>
> Anyway, could you post some oprofile results ?

Hopefully soon -- want to still make sure I'm not doing something
dumb. Am also hoping to get some of the gdb backtraces like Anton had.

Thanks,
Nish
