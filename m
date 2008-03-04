Return-Path: <linux-kernel-owner+w=401wt.eu-S932509AbYCDSgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbYCDSgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764092AbYCDSgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:36:17 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:3005 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763417AbYCDSgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:36:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ArGQNyfCpevlcZsstkzsjVCqAhNvD7Y5JS4opvZZt2CxP84mt07mVYtJlL4o2Y9z6BDofHLtDwW9AtwhP1zYsBHbR+7Hx+z9Az6lVtR8LxK5snxAmg+tIl5Txn5twttTLvRBOj+CzMkEhLOVBQx9MdhqXbFTrutSODR+xgmuGV8=
Message-ID: <47CD968B.1070302@gmail.com>
Date: Wed, 05 Mar 2008 03:35:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: FUJITA Tomonori <tomof@acm.org>, efault@gmx.de, jens.axboe@oracle.com,
       fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <20080304093536.GH6704@kernel.dk>	<1204634238.5997.5.camel@homer.simson.net>	<47CD4355.4050401@gmail.com> <20080304223006A.tomof@acm.org> <47CD53BA.5040908@gmail.com> <47CD7611.2030606@gmail.com> <47CD7C05.1080707@gmail.com> <47CD9457.3090203@panasas.com>
In-Reply-To: <47CD9457.3090203@panasas.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
>> -	good_bytes = scsi_bufflen(cmd);
>> +	good_bytes = scsi_bufflen(cmd) + cmd->request->data_len;
> 
> Are you sure? is it not:
> +	good_bytes = scsi_bufflen(cmd) + cmd->request->extra_len

You're right.  Sorry about the confusion.

>>          if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
>>  		drv = scsi_cmd_to_driver(cmd);
>>  		if (drv->done)
>>
>>
> 
> I hate this patch. I wish you could maybe take the extra_len into 
> account inside blk_end_request. The padding should be transparent
> to all concerned but the requesting LLD and the internals of the
> block layer. If block layer added padding it should take that into
> account on completion. My $0.2.

Yeah, I hate it too.  As I've been saying all along, I think it just
should be rq->data_len.

-- 
tejun
