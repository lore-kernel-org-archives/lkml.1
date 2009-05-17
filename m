Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbZEQLdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbZEQLdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 07:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZEQLdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 07:33:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:6401 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbZEQLdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 07:33:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kAWP74YnPtu7gREMuPQOw6+ysz434b2sFyI+G0p8ozI62bMuGDgeTwthYZTYDcgtyz
         ojrgycHRODyZNiQQqoki6IVxY/BpSQy/kbKXeVVSwYxxfMT8EJFPydF37Dro90Yu9Dt6
         No+fDmfBMM+oKGoSZZuWAwcG2rLVxa4GXzfcM=
Message-ID: <4A0FF5EA.3020805@gmail.com>
Date: Sun, 17 May 2009 20:32:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Pete Zaitcev <zaitcev@redhat.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH UPDATED block#for-2.6.31 2/3] block: set rq->resid_len
 to blk_rq_bytes() on issue
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com> <4A0E0650.1020500@gmail.com> <4A0FCF52.7070406@panasas.com>
In-Reply-To: <4A0FCF52.7070406@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:
> Surly this is not enough. This is not the only place rq->__data_len
> gets a value.  Specifically it can be added to in blk_rq_append_bio.
> You must then update all places that set rq->__data_len to also set
> rq->resid_len.

Right, nice spotting, but I think those are the only two places.  You
now see why I don't like that append thing.  :-)

> Alternatively you could do a single:
> +	rq->resid_len = blk_rq_bytes(rq);
> 
> inside  blk_fetch_request(q) or before the call to prep_fn, or even at
> __elv_add_request().

I think I'll just add resid_len adjustment there right after
__data_len manipulation.  That code path should really go away
eventually.

Thanks.

-- 
tejun
