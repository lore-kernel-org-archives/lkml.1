Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZLXJTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZLXJTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 04:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbZLXJTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 04:19:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:61146 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbZLXJTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 04:19:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,448,1257148800"; 
   d="scan'208";a="581823027"
Date: Thu, 24 Dec 2009 17:19:19 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "czoccolo@gmail.com" <czoccolo@gmail.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: cfq-iosched: tiobench regression
Message-ID: <20091224091919.GA17516@sli10-desk.sh.intel.com>
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
 <4B331CD6.1070207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B331CD6.1070207@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 03:48:38PM +0800, Gui Jianfeng wrote:
> Shaohua Li wrote:
> > We see about 30% regression in tiobench 32 threads 80M file sequential read.
> > The regression is caused by below commits.
> > 
> > 5db5d64277bf390056b1a87d0bb288c8b8553f96
> > The commit makes the slice too small. In the test, the slice is limitted
> > to 2 * idle_slice(300ms/32 < 2*idle_slice). This dramatically impacts io
> > thoughput. The low_latency knob used to be only impact random io, now it
> > impacts sequential io too. Any idea to fix it?
> 
> Hi Shaohua,
> 
> IMHO this shouldn't be a problem. Currently, low_latency is used to improve
> the latency for the whole system. If someone would like to achieve high throughput,
> just turn off low_latency knob.
The concern is low_latency is default on. A end user is unlikely to know the knob.

Thanks,
Shaohua
