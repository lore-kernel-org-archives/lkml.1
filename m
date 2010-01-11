Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387Ab0AKNSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab0AKNSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 08:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304Ab0AKNSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 08:18:09 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50244 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab0AKNSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 08:18:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QOt0/aftUmLB1Fh6cBS1ahxxGzCL3/8pp65VToXR1QdZhuphDkmcZ2yH7a4BTcg8gM
         IaLsJZ34NmmDyZvL+ZJ18V+xayTRBvuvwkuWilNe529QC48IZ0IEfMkzN7IN8WmSnxaE
         B1BVITBSJ2XAQnw+AiK39pr6Ef132Vg6rJ0Kk=
Message-ID: <4B4B250D.8020205@garzik.org>
Date: Mon, 11 Jan 2010 08:18:05 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: NCQ SSDs do not need read queue merging
References: <1262211768-10858-1-git-send-email-czoccolo@gmail.com> <1263157461-12294-1-git-send-email-czoccolo@gmail.com> <4B4B0AA9.5020900@garzik.org> <4e5e476b1001110426t2afa0502p7f19a9b24e48ba82@mail.gmail.com> <20100111131317.GB4489@kernel.dk>
In-Reply-To: <20100111131317.GB4489@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2010 08:13 AM, Jens Axboe wrote:
> On Mon, Jan 11 2010, Corrado Zoccolo wrote:
>> On Mon, Jan 11, 2010 at 12:25 PM, Jeff Garzik<jeff@garzik.org>  wrote:
>>> On 01/10/2010 04:04 PM, Corrado Zoccolo wrote:
>>>>
>>>> NCQ SSDs' performances are not affected by
>>>> distance of read requests, so there is no point in having
>>>> overhead to merge such queues.
>>>>
>>>> Non-NCQ SSDs showed regression in some special cases, so
>>>> they are ruled out by this patch.
>>>>
>>>> This patch intentionally doesn't affect writes, so
>>>> it changes the queued[] field, to be indexed by
>>>> READ/WRITE instead of SYNC/ASYNC, and only compute proximity
>>>> for queues with WRITE requests.
>>>>
>>>> Signed-off-by: Corrado Zoccolo<czoccolo@gmail.com>
>>>
>>> That's not really true.  Overhead always increases as the total number of
>>> ATA commands issued increases.
>>
>> Jeff Moyer tested the patch on the workload that mostly benefit of
>> queue merging, and found that
>> the performance was improved by the patch.
>> So removing the CPU overhead helps much more than the marginal gain
>> given by merging on this hardware.
>
> It's not always going to be true. On SATA the command overhead is fairly
> low, but on other hardware that may not be the case. Unless you are CPU
> bound by your IO device, then merging will always be beneficial. I'm a
> little behind on emails after my vacation, Jeff what numbers did you
> generate and on what hardware?

  ...and on what workload?   "the workload that mostly benefit of queue 
merging" is highly subjective, and likely does not cover most workloads 
SSDs will see in the field.

	Jeff



