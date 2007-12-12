Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbXLLSOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbXLLSOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXLLSNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:13:50 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20485 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751917AbXLLSNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:13:49 -0500
Message-ID: <4760248B.6010904@panasas.com>
Date: Wed, 12 Dec 2007 20:12:27 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
CC: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, grant.likely@secretlab.ca
Subject: Re: [PATCH 20/30] blk_end_request: changing xsysace (take 4)
References: <20071211.174946.85815368.k-ueda@ct.jp.nec.com>	<475FA538.7000609@panasas.com> <20071212.120648.71084437.k-ueda@ct.jp.nec.com>
In-Reply-To: <20071212.120648.71084437.k-ueda@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2007 18:12:33.0695 (UTC) FILETIME=[913FCAF0:01C83CEA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12 2007 at 19:06 +0200, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> Hi,
> 
> On Wed, 12 Dec 2007 11:09:12 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
>>> Index: 2.6.24-rc4/drivers/block/xsysace.c
>>> ===================================================================
>>> --- 2.6.24-rc4.orig/drivers/block/xsysace.c
>>> +++ 2.6.24-rc4/drivers/block/xsysace.c
>>> @@ -703,7 +703,7 @@ static void ace_fsm_dostate(struct ace_d
>>>  
>>>  		/* bio finished; is there another one? */
>>>  		i = ace->req->current_nr_sectors;
>>> -		if (end_that_request_first(ace->req, 1, i)) {
>>> +		if (__blk_end_request(ace->req, 0, i)) {
>> end_that_request_first() took sectors __blk_end_request() now takes
>> bytes
> 
> Thank you for pointing it out!  And I'm very sorry for the bug.
> I have checked all conversions between sectors and bytes through
> all patches again, and I found no other miss conversions.
> 
> Below is the revised patch for xsysace.
> 
> Thanks,
> Kiyoshi Ueda
> 
> 
NP, I know how it is, after you rebased your work for the 
"who's counting" times, you become blind. You need fresh
eyes to look at it. Thanks for doing all this.

Boaz
