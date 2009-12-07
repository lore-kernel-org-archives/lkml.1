Return-Path: <linux-kernel-owner+w=401wt.eu-S934831AbZLGIuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934831AbZLGIuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:50:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934789AbZLGIuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:50:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51550 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934796AbZLGIt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:49:58 -0500
Message-ID: <4B1CC0BD.1000405@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 16:45:49 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, jens.axboe@oracle.com
CC: linux-kernel@vger.kernel.org, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, czoccolo@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: Block IO Controller V4
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <4B15C828.4080407@cn.fujitsu.com> <20091202142508.GA31715@redhat.com> <4B1779CE.1050801@cn.fujitsu.com> <20091203143641.GA3887@redhat.com> <20091203181003.GD2735@redhat.com> <20091203235153.GG2735@redhat.com>
In-Reply-To: <20091203235153.GG2735@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Thu, Dec 03, 2009 at 01:10:03PM -0500, Vivek Goyal wrote:
> 
> [..]
>> Hi Gui,
>>
>> Can you please try following patch and see if it helps you. If not, then
>> we need to figure out why we choose to not idle and delete the group from
>> service tree.
>>
> 
> Hi Gui,
> 
> Please try this version of the patch instead of previous one. During more
> testing I saw some additional deletions where we should have waited and
> the reason being that we were hitting boundary condition. At the request
> completion time slice has not expired but after 4-5 ns, select_queue hits
> and jiffy has incremented by then and slice expires.
> 
> ttime_mean, is not covering this condition because this workload is so
> sequential that ttime_mean=0.
> 
> So I am checking for new condition where if we are into last ms of slice,
> mark the queue wait_busy.
> 
> Thanks
> Vivek
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Hi, Vivek

I add some debug message in select_queue, it does meet the boundary condition. 
I tried this patch, and works fine on my box.

Acked-by: Gui Jianfeng <guijiafneng@cn.fujitsu.com>

Thanks,
Gui

