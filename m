Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbXLDN6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbXLDN6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbXLDNzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:55:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:48756 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbXLDNzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:55:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=YpenTQj7qDW7M7tdblfwtY27wyy6mFDJfAHwNuxteIDaDjHFZMmSNNiySis9Km31cWSZCGvFcnDXLnkyIB+hucv9CYk/1ZWZtsVIY/HLy8k7MSH156kh+HCjcztd7OQCeehsH87cIiZARQUGIvi1xQ7T7sNL5/sEhN7019vtbWM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 26/28] blk_end_request: changing ide-cd (take 3)
Date: Tue, 4 Dec 2007 14:46:51 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
References: <20071130.183447.82055860.k-ueda@ct.jp.nec.com> <200712012342.52134.bzolnier@gmail.com> <20071203.175212.52162634.k-ueda@ct.jp.nec.com>
In-Reply-To: <20071203.175212.52162634.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712041446.52249.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 03 December 2007, Kiyoshi Ueda wrote:

[...]

> Thank you for the comments.
> I rebased my patch on top of 2.6.24-rc3-mm2 + the patch to remove
> post_transform_command().
> 
> As a result, one callback function for DMA mode has been removed.
> What do you think about the patch below?
> 
> 
> 
> Subject: [PATCH 26/28] blk_end_request: changing ide-cd (take 3)
> 
> 
> This patch converts ide-cd (cdrom_newpc_intr()) to use blk_end_request
> interfaces.
> 
> In PIO mode, ide-cd (cdrom_newpc_intr()) needs to defer
> end_that_request_last() until the device clears DRQ_STAT and raises
> an interrupt after end_that_request_first().
> So blk_end_request() has to return without completing request
> even if no leftover in the request.
> 
> ide-cd uses blk_end_request_callback() and a dummy callback function,
> which just returns value '1', to tell blk_end_request_callback()
> about that.
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Looks good, thanks!

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
