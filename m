Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbZLXHxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbZLXHxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 02:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbZLXHxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 02:53:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60082 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbZLXHxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 02:53:15 -0500
Message-ID: <4B331CD6.1070207@cn.fujitsu.com>
Date: Thu, 24 Dec 2009 15:48:38 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, jmoyer@redhat.com,
       czoccolo@gmail.com, yanmin.zhang@intel.com
Subject: Re: cfq-iosched: tiobench regression
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
In-Reply-To: <20091224005506.GA7879@sli10-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> We see about 30% regression in tiobench 32 threads 80M file sequential read.
> The regression is caused by below commits.
> 
> 5db5d64277bf390056b1a87d0bb288c8b8553f96
> The commit makes the slice too small. In the test, the slice is limitted
> to 2 * idle_slice(300ms/32 < 2*idle_slice). This dramatically impacts io
> thoughput. The low_latency knob used to be only impact random io, now it
> impacts sequential io too. Any idea to fix it?

Hi Shaohua,

IMHO this shouldn't be a problem. Currently, low_latency is used to improve
the latency for the whole system. If someone would like to achieve high throughput,
just turn off low_latency knob.

