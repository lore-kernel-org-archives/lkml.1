Return-Path: <linux-kernel-owner+w=401wt.eu-S935324AbZLGP0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935324AbZLGP0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935286AbZLGP0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:26:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935271AbZLGP0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:26:42 -0500
Date: Mon, 7 Dec 2009 10:25:31 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Re: Block IO Controller V4
Message-ID: <20091207152531.GB16900@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <4B15C828.4080407@cn.fujitsu.com> <20091202142508.GA31715@redhat.com> <4B1779CE.1050801@cn.fujitsu.com> <20091203143641.GA3887@redhat.com> <20091203181003.GD2735@redhat.com> <20091203235153.GG2735@redhat.com> <4B1CC0BD.1000405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1CC0BD.1000405@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 04:45:49PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > On Thu, Dec 03, 2009 at 01:10:03PM -0500, Vivek Goyal wrote:
> > 
> > [..]
> >> Hi Gui,
> >>
> >> Can you please try following patch and see if it helps you. If not, then
> >> we need to figure out why we choose to not idle and delete the group from
> >> service tree.
> >>
> > 
> > Hi Gui,
> > 
> > Please try this version of the patch instead of previous one. During more
> > testing I saw some additional deletions where we should have waited and
> > the reason being that we were hitting boundary condition. At the request
> > completion time slice has not expired but after 4-5 ns, select_queue hits
> > and jiffy has incremented by then and slice expires.
> > 
> > ttime_mean, is not covering this condition because this workload is so
> > sequential that ttime_mean=0.
> > 
> > So I am checking for new condition where if we are into last ms of slice,
> > mark the queue wait_busy.
> > 
> > Thanks
> > Vivek
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Hi, Vivek
> 
> I add some debug message in select_queue, it does meet the boundary condition. 
> I tried this patch, and works fine on my box.
> 
> Acked-by: Gui Jianfeng <guijiafneng@cn.fujitsu.com>

Thanks Gui, I will send this patch to Jens in a separate mail.

Thanks
Vivek
