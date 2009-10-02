Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZJBW2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZJBW2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZJBW2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:28:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbZJBW2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:28:44 -0400
Date: Fri, 2 Oct 2009 18:27:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, Mike Galbraith <efault@gmx.de>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20091002222756.GG4494@redhat.com>
References: <200910021255.27689.czoccolo@gmail.com> <20091002124921.GA4494@redhat.com> <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com> <1254497520.10392.11.camel@marge.simson.net> <20091002154020.GC4494@redhat.com> <12774.1254502217@turing-police.cc.vt.edu> <20091002195815.GE4494@redhat.com> <4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 12:14:28AM +0200, Corrado Zoccolo wrote:
> On Fri, Oct 2, 2009 at 9:58 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Oct 02, 2009 at 12:50:17PM -0400, Valdis.Kletnieks@vt.edu wrote:
> >> On Fri, 02 Oct 2009 11:40:20 EDT, Vivek Goyal said:
> >>
> >> Umm... I got petabytes of hardware RAID across the hall that very definitely
> >> *is* rotating.  Did you mean "SSD and disk systems with big honking caches
> >> that cover up the rotation"?  Because "RAID" and "big honking caches" are
> >> not *quite* the same thing, and I can just see that corner case coming out
> >> to bite somebody on the ass...
> >>
> >
> > I guess both. The systems which have big caches and cover up for rotation,
> > we probably need not idle for seeky process. An in case of big hardware
> > RAID, having multiple rotating disks, instead of idling and keeping rest
> > of the disks free, we probably are better off dispatching requests from
> > next queue (hoping it is going to a different disk altogether).
> 
> In fact I think that the 'rotating' flag name is misleading.
> All the checks we are doing are actually checking if the device truly
> supports multiple parallel operations, and this feature is shared by
> hardware raids and NCQ enabled SSDs, but not by cheap SSDs or single
> NCQ-enabled SATA disk.
> 

While we are at it, what happens to notion of priority of tasks on SSDs?
Without idling there is not continuous time slice and there is no
fairness. So ioprio is out of the window for SSDs?

On SSDs, will it make more sense to provide fairness in terms of number or
IO or size of IO and not in terms of time slices.

Thanks
Vivek

> If we really wanted a "seek is cheap" flag, we could measure seek time
> in the io-scheduler itself, but in the current code base we don't have
> it used in this meaning anywhere.
> 
> Thanks,
> Corrado
> 
> >
> > Thanks
> > Vivek
> >
> 
> 
> 
> -- 
> __________________________________________________________________________
> 
> dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
> PhD - Department of Computer Science - University of Pisa, Italy
> --------------------------------------------------------------------------
> The self-confidence of a warrior is not the self-confidence of the average
> man. The average man seeks certainty in the eyes of the onlooker and calls
> that self-confidence. The warrior seeks impeccability in his own eyes and
> calls that humbleness.
>                                Tales of Power - C. Castaneda
