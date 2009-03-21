Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZCUDAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZCUDAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 23:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZCUDAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 23:00:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:34694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbZCUDAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 23:00:14 -0400
Message-ID: <49C457C3.6080909@kernel.org>
Date: Sat, 21 Mar 2009 11:58:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
CC: =?UTF-8?B?SsO2cmcgRG9yY2hhaW4=?= <joerg@dorchain.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Tim Waugh <tim@cyberelk.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [PATCH 15/17] block: kill end_request()
References: <1237170540-19130-1-git-send-email-tj@kernel.org> <1237170540-19130-16-git-send-email-tj@kernel.org>
In-Reply-To: <1237170540-19130-16-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 21 Mar 2009 02:57:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Impact: kill obsolete interface function
> 
> end_request() has been kept around for backward compatibility;
> however, it seems to be about time for it to go away.
> 
> * There aren't too many users left.
> 
> * Its use of @updtodate is pretty confusing.
> 
> * In some cases, newer code ends up using mixture of end_request() and
>   [__]blk_end_request[_all](), which is way too confusing.
> 
> So, kill it.
> 
> Most conversions are straightforward.  Noteworthy ones are...
> 
> * paride/pcd: next_request() updated to take 0/-errno instead of 1/0.
> 
> * paride/pf: pf_end_request() and next_request() updated to take
>   0/-errno instead of 1/0.
> 
> * xd: xd_readwrite() updated to return 0/-errno instead of 1/0.
> 
> * mtd/mtd_blkdevs: blktrans_discard_request() updated to return
>   0/-errno instead of 1/0.  Unnecessary local variable res
>   initialization removed from mtd_blktrans_thread().

This patch isn't correct.  Will post updated version later.

Thanks.

-- 
tejun
