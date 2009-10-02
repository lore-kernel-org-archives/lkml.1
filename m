Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZJBUAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZJBUAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbZJBUAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:00:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756938AbZJBUAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:00:00 -0400
Date: Fri, 2 Oct 2009 15:58:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Mike Galbraith <efault@gmx.de>, Corrado Zoccolo <czoccolo@gmail.com>,
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
Message-ID: <20091002195815.GE4494@redhat.com>
References: <200910021255.27689.czoccolo@gmail.com> <20091002124921.GA4494@redhat.com> <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com> <1254497520.10392.11.camel@marge.simson.net> <20091002154020.GC4494@redhat.com> <12774.1254502217@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12774.1254502217@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 12:50:17PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 02 Oct 2009 11:40:20 EDT, Vivek Goyal said:
> 
> > In that case, Corrado's suggestion of refining it further and disabling idling
> > for seeky process only on non-rotational media (SSD and hardware RAID), makes
> > sense to me.
> 
> Umm... I got petabytes of hardware RAID across the hall that very definitely
> *is* rotating.  Did you mean "SSD and disk systems with big honking caches
> that cover up the rotation"?  Because "RAID" and "big honking caches" are
> not *quite* the same thing, and I can just see that corner case coming out
> to bite somebody on the ass...
>

I guess both. The systems which have big caches and cover up for rotation,
we probably need not idle for seeky process. An in case of big hardware
RAID, having multiple rotating disks, instead of idling and keeping rest
of the disks free, we probably are better off dispatching requests from
next queue (hoping it is going to a different disk altogether).

Thanks
Vivek
