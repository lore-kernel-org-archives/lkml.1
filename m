Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZLBBzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZLBBzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbZLBBzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:55:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52804 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbZLBBzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:55:40 -0500
Message-ID: <4B15C828.4080407@cn.fujitsu.com>
Date: Wed, 02 Dec 2009 09:51:36 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Re: Block IO Controller V4
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Hi Jens,
> 
> This is V4 of the Block IO controller patches on top of "for-2.6.33" branch
> of block tree.
> 
> A consolidated patch can be found here:
> 
> http://people.redhat.com/vgoyal/io-controller/blkio-controller/blkio-controller-v4.patch
> 

Hi Vivek,

It seems this version doesn't work very well for "direct(O_DIRECT) sequence read" mode.
For example, you can create group A and group B, then assign weight 100 to group A and
weight 400 to group B, and you run "direct sequence read" workload in group A and B 
simultaneously. Ideally, we should see 1:4 disk time differentiation for group A and B. 
But actually, I see almost 1:2 disk time differentiation for group A and B. I'm looking
into this issue.
BTW, V3 works well for this case.

Thanks,
Gui

