Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbXGMBxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbXGMBxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 21:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbXGMBxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 21:53:00 -0400
Received: from mga05.intel.com ([192.55.52.89]:33921 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753701AbXGMBw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 21:52:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,535,1175497200"; 
   d="scan'208";a="267702981"
Subject: Re: [PATCH] Optimize struct task_delay_info
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Shailabh Nagar <nagar1234@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <y0mzm21eb4y.fsf@ton.toronto.redhat.com>
References: <1184138034.3068.51.camel@ymzhang>
	 <p73d4yzyvkw.fsf@bingen.suse.de> <1184229443.3068.55.camel@ymzhang>
	 <y0mzm21eb4y.fsf@ton.toronto.redhat.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 13 Jul 2007 09:52:14 +0800
Message-Id: <1184291534.4688.26.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 14:21 -0400, Frank Ch. Eigler wrote:
> "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> writes:
> 
> > [...]
> > > > 2) Delete lock. [..]
> > > > In addition, the result is for performance data collection, so it's
> > > > unnecessary to add such lock.
> > > Not sure that's a good idea. People expect their performance counts
> > > to be accurate too. [...]
> > [...]
> > 2) If the reader could get the correct data when the process updates
> > the data. It might be an issue. But the issue is not
> > important. Mostly, the application tool reads the data in an
> > interval.
> 
> Can you elaborate on that some more? 
If there is no the lock, the blkio_delay/swapin_delay might have the latest
value but the count is 1 less than the correct value.

> Is it OK for the sample
> monitoring program to return inconsistent data sometimes?
That needs Shailabh Nagar's comments.

What I tried to say is the inconsistent issue is not severe and happened rarely.
The mostly-used scenario is a performance tool reads the data per time-slot in
a loop, so I think it wouldn't hurt the usage model.

>   Is there
> reason to believe that this sample user-space program will remain the
> sole consumer of this data?  Might a seqlock be appropriate here?
seqlock is helpful, but my start point is to save memory space without hurt to application.
As you know, every process (thread) has its own struct task_delay_info.

Yanmin
