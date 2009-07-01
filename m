Return-Path: <linux-kernel-owner+w=401wt.eu-S1763906AbZGABin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763906AbZGABin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758386AbZGABie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:38:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35412 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757146AbZGABie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:38:34 -0400
Date: Tue, 30 Jun 2009 21:34:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Nauman Rafique <nauman@google.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH] io-controller: optimization for iog deletion when
	elevator exiting
Message-ID: <20090701013425.GC13958@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-6-git-send-email-vgoyal@redhat.com> <4A4850D3.3000700@cn.fujitsu.com> <20090629140631.GA4622@redhat.com> <e98e18940906301014n146e7146vb5a73c2f33c9e819@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e98e18940906301014n146e7146vb5a73c2f33c9e819@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 10:14:48AM -0700, Nauman Rafique wrote:
> On Mon, Jun 29, 2009 at 7:06 AM, Vivek Goyal<vgoyal@redhat.com> wrote:
> > On Mon, Jun 29, 2009 at 01:27:47PM +0800, Gui Jianfeng wrote:
> >> Hi Vivek,
> >>
> >> There's no need to travel the iocg->group_data for each iog
> >> when exiting a elevator, that costs too much. An alternative
> >> solution is reseting iocg_id as soon as an io group unlinking
> >> from a iocg. Make a decision that whether it's need to carry
> >> out deleting action by checking iocg_id.
> >>
> >
> > Thanks Gui. This makes sense to me. We can check iog->iocg_id to determine
> > wheter group is still on iocg list or not instead of traversing the list.
> >
> > Nauman, do you see any issues with the patch?
> 
> Looks like this should work. The only iog with zero id is associated
> with root group, which gets deleted outside of this function anyways.
> 

Minor correction. Even root group has id "1" and not zero. 0 is associated
with error when cgroup is not present.

Thanks
Vivek
