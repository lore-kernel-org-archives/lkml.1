Return-Path: <linux-kernel-owner+w=401wt.eu-S1761670AbYCCEJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761670AbYCCEJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbYCCEJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:09:23 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:53489 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbYCCEJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:09:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DKyvpVq0SDCEOC+0UbfTFPAVH2WEX5THEZN1drSbdFO+Z7Oa5NNXbh/4g3MbEBZJqU0Hy3Wqc/CxszYi2gG5TZwFG9BHr/lxLwVbnBFxzOYsGl4+2pbWgXpoZjqh/Bj+3YJ7y3O46W9Y55r74vSCcLBBfe5lLC4gCe2SNSwPQyk=
Message-ID: <47CB79E9.8000505@gmail.com>
Date: Mon, 03 Mar 2008 13:09:13 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: tomof@acm.org, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com, efault@gmx.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <47C8F4FC.1040505@gmail.com>	<20080302235223X.tomof@acm.org>	<47CB6508.3040206@gmail.com> <20080303125940T.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080303125940T.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>> - I think bugs caused by using raw_data_len instead of data_len are more
>> subtle than the other way around.  Using data_len instead of
>> raw_data_len usually affects the application layer while using
>> raw_data_len instead of data_len affects the DMA engine and transport layer.
> 
> If we add extra_len, we can get what raw_data_len and data_len
> provide.
> 
> I can't see what changing the meaning of rq->data_len (and
> investigating all the block drivers) gives us.

No matter which way you go, you change the meaning of rq->data_len and
you MUST inspect rq->data_len usage whichever way you go.  Apply your
patch and try to do sg IO on IDE cdrom w/ various transfer lengths.

-- 
tejun
