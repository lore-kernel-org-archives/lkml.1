Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076Ab0AMIX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab0AMIX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991Ab0AMIX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:23:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:58472 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab0AMIXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:23:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232171965"
Date: Wed, 13 Jan 2010 16:23:22 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "vgoyal@redhat.com" <vgoyal@redhat.com>,
       "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
       "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH]cfq-iosched: don't stop async queue with async requests
 pending
Message-ID: <20100113082322.GA24345@sli10-desk.sh.intel.com>
References: <20100113074442.GA10492@sli10-desk.sh.intel.com>
 <4e5e476b1001130018n2ad9e830s4a20d922abd4c7bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b1001130018n2ad9e830s4a20d922abd4c7bb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 04:18:47PM +0800, Corrado Zoccolo wrote:
> On Wed, Jan 13, 2010 at 8:44 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > My SSD speed of direct write is about 80m/s, while I test page writeback,
> > the speed can only go to 68m/s. Below patch fixes this.
> > It appears we missused cfq_should_idle in cfq_may_dispatch. cfq_should_idle
> > means a queue should idle because it's seekless sync queue or it's the last queue,
> > which is to maintain service tree time slice. So it doesn't mean the
> > last queue is always a sync queue. If the last queue is asyn queue,
> > we definitely shouldn't stop dispatch requests because of pending async
> > requests.
> 
> An other option is that cfq_should_idle returns false for async
> queues, since cfq will never idle on them.
I'm considering this option too, but it appears we need make async queue
idle to maintain domain time slice.

Thanks,
Shaohua
