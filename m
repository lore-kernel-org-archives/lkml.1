Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbXIDXOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbXIDXOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 19:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbXIDXN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 19:13:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbXIDXN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 19:13:57 -0400
Date: Tue, 04 Sep 2007 19:13:18 -0400 (EDT)
Message-Id: <20070904.191318.23007091.k-ueda@ct.jp.nec.com>
To: bhalevy@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, jens.axboe@oracle.com, mike.miller@hp.com,
       grant.likely@secretlab.ca, bharrosh@panasas.com, dm-devel@redhat.com,
       j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: Re: [PATCH 6/7] blk_end_request: remove/unexport end_that_request_*
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <E472128B1EB43941B4E7FB268020C89B02992D9B@riverside.int.panasas.com>
References: <20070831.184335.85683085.k-ueda@ct.jp.nec.com>
	<E472128B1EB43941B4E7FB268020C89B02992D9B@riverside.int.panasas.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 4 Sep 2007 17:25:14 -0400, "Halevy, Benny" <bhalevy@panasas.com> wrote:
> We suspect we'll still need the extern entry points for handling the bidi 
> request in the scsi_io_completion() path as we only want to call
> end_that_request_chunk on req->next_rq and never
> end_that_request_last.
>  
> (see 
> http://www.bhalevy.com/open-osd/download/linux-2.6.23-rc2_and_iscsi-iscsi-2007_08_09/0005-SCSI-bidi-support.patch)

If this patch-set is merged, there may be other way to do that.

For tricky drivers, special interface, blk_end_request_callback(),
is added in the patch 5/7.
(http://marc.info/?l=linux-kernel&m=118860027714753&w=2)
Currently, only user of the interface is ide-cd (cdrom_newpc_intr()).
It needs to call only end_that_request_first() too.

With the patch 7/7, you can set your own handler in rq->end_io()
to complete the request by your own way.

Thanks,
Kiyoshi Ueda
