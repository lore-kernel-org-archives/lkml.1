Return-Path: <linux-kernel-owner+w=401wt.eu-S932980AbZGPSQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbZGPSQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 14:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932952AbZGPSQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 14:16:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55688 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870AbZGPSQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 14:16:30 -0400
Message-ID: <4A5F6E2C.8020609@vlnb.net>
Date: Thu, 16 Jul 2009 22:15:08 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joe Eykholt <jeykholt@cisco.com>
CC: Boaz Harrosh <bharrosh@panasas.com>, Tejun Heo <tj@kernel.org>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH v2]: New implementation of scsi_execute_async()
References: <4A563368.5040407@vlnb.net> <4A5CAFB5.1000901@vlnb.net> <4A5D9C46.2000002@panasas.com> <4A5E168B.8010809@cisco.com>
In-Reply-To: <4A5E168B.8010809@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19+C9+zfhN3bj6fNgLyVnntXd8UP+tum6YtCn8
 jRIreTj98V+Ap0Kpe13lBUgUNdu8m9Mw2HTnlnaObasct2RWfv
 llmF/wH6T92NGXnv8WwfQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Eykholt, on 07/15/2009 09:48 PM wrote:
>>> +int sg_copy(struct scatterlist *dst_sg,
>>> +	    struct scatterlist *src_sg, size_t copy_len,
>>> +	    enum km_type d_km_type, enum km_type s_km_type)
>>> +{
>>> +	int res = 0;
>>> +	size_t dst_len, dst_offs;
>>> +
>>> +	if (copy_len == 0)
>>> +		copy_len = 0x7FFFFFFF; /* copy all */
>>> +
>>> +	dst_len = dst_sg->length;
>>> +	dst_offs = dst_sg->offset;
>>> +
>>> +	do {
>>> +		copy_len -= __sg_copy_elem(&dst_sg, &dst_len, &dst_offs,
>>> +				src_sg, copy_len, d_km_type, s_km_type);
>>> +		if ((copy_len == 0) || (dst_sg == NULL))
>>> +			goto out;
>>> +
>>> +		src_sg = sg_next(src_sg);
>>> +	} while (src_sg != NULL);
>>> +
>>> +out:
>>> +	return res;
>>> +}
> 
> The return value res is always 0 here, contrary to the description.
> Maybe it should be void.

Will be fixed, thanks

>>> +EXPORT_SYMBOL(sg_copy);
>>>
>> Boaz
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

