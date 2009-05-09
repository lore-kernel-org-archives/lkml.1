Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZEIJYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZEIJYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 05:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZEIJYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 05:24:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:56454 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbZEIJYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 05:24:11 -0400
Subject: Re: IO scheduler based IO Controller V2
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrea Righi <righi.andrea@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com,
       m-ikeda@ds.jp.nec.com
In-Reply-To: <20090508215618.GJ7293@redhat.com>
References: <20090506203228.GH8180@redhat.com> <20090506213453.GC4282@linux>
	 <20090506215235.GJ8180@redhat.com> <20090507090450.GA4613@linux>
	 <20090507141126.GA9463@redhat.com> <20090507144501.GB9463@redhat.com>
	 <20090507153642.GC9463@redhat.com> <20090507221900.GA29774@linux>
	 <20090508180951.GG7293@redhat.com> <20090508200458.GA3708@linux>
	 <20090508215618.GJ7293@redhat.com>
Content-Type: text/plain
Date: Sat, 09 May 2009 11:22:52 +0200
Message-Id: <1241860972.6316.91.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 17:56 -0400, Vivek Goyal wrote:
>   So, we shall have to come up with something better, I think Dhaval was
>   implementing upper limit for cpu controller. May be PeterZ and Dhaval can
>   give us some pointers how did they manage to implement both proportional
>   and max bw control with the help of a single tree while maintaining the
>   notion of prio with-in cgroup.

We don't do max bandwidth control in the SCHED_OTHER bits as I oppose to
making it non work conserving.

SCHED_FIFO/RR do constant bandwidth things and are always scheduled in
favour of SCHED_OTHER. 

That is, we provide a minimum bandwidth for real-time tasks, but since
having a maximum higher than the minimum is useless since one cannot
rely on it (non deterministic) we put max = min.

