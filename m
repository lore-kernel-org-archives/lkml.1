Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbXIEHjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbXIEHjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 03:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbXIEHiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 03:38:52 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13858 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754175AbXIEHiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 03:38:51 -0400
Message-ID: <46DE5C90.2020700@panasas.com>
Date: Wed, 05 Sep 2007 10:36:48 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, jens.axboe@oracle.com
CC: bhalevy@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca, dm-devel@redhat.com,
       j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 6/7] blk_end_request: remove/unexport end_that_request_*
References: <20070831.184335.85683085.k-ueda@ct.jp.nec.com>	<E472128B1EB43941B4E7FB268020C89B02992D9B@riverside.int.panasas.com> <20070904.191318.23007091.k-ueda@ct.jp.nec.com>
In-Reply-To: <20070904.191318.23007091.k-ueda@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Sep 2007 07:36:57.0782 (UTC) FILETIME=[89FDC560:01C7EF8F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05 2007 at 2:13 +0300, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> Hi,
> 
> On Tue, 4 Sep 2007 17:25:14 -0400, "Halevy, Benny" <bhalevy@panasas.com> wrote:
>> We suspect we'll still need the extern entry points for handling the bidi 
>> request in the scsi_io_completion() path as we only want to call
>> end_that_request_chunk on req->next_rq and never
>> end_that_request_last.
>>  
>> (see 
>> http://www.bhalevy.com/open-osd/download/linux-2.6.23-rc2_and_iscsi-iscsi-2007_08_09/0005-SCSI-bidi-support.patch)
> 
> If this patch-set is merged, there may be other way to do that.
> 
> For tricky drivers, special interface, blk_end_request_callback(),
> is added in the patch 5/7.
> (http://marc.info/?l=linux-kernel&m=118860027714753&w=2)
> Currently, only user of the interface is ide-cd (cdrom_newpc_intr()).
> It needs to call only end_that_request_first() too.
> 
> With the patch 7/7, you can set your own handler in rq->end_io()
> to complete the request by your own way.
> 
> Thanks,
> Kiyoshi Ueda

That will not work, as I will have no means of releasing the BIOs of
the bidi request, which can not use end_request().

I guess as Jens said it's OK to remove them now, and later we can
just add end_that_request_first(), will be enough.
Or we can patch end_request() to also call 
__end_that_request_first(req->next_rq) if not NULL.

Jens which method do you prefer? I will adjust my patches accordingly.

Thanks
Boaz Harrosh

