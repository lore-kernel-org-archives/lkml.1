Return-Path: <linux-kernel-owner+w=401wt.eu-S1763193AbYCEG10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763193AbYCEG10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 01:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762534AbYCEG1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 01:27:09 -0500
Received: from fwil.voltaire.com ([193.47.165.2]:45633 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762472AbYCEG1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 01:27:07 -0500
Message-ID: <47CE3D33.7060805@voltaire.com>
Date: Wed, 05 Mar 2008 08:26:59 +0200
From: Erez Zilber <erezz@voltaire.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Arne Redlich <arne.redlich@xiranet.com>, Roland Dreier <rolandd@cisco.com>
CC: ofa-general <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] IB/iSER: fix list iteration bug
References: <877igkxffl.fsf@confield.dd.xiranet.com>	<47CD3B7A.2010106@voltaire.com> <878x0yfqe7.fsf@confield.dd.xiranet.com>
In-Reply-To: <878x0yfqe7.fsf@confield.dd.xiranet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2008 06:27:00.0325 (UTC) FILETIME=[EB4B2950:01C87E89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arne Redlich wrote:

> Erez Zilber <erezz@voltaire.com> writes:
>
>   
>> Arne Redlich wrote:
>>     
>>> The iteration through the list of "iser_device"s during device
>>> lookup/creation is broken - it might result in an infinite loop if more
>>> than 1 HCA is used with iSER. Use list_for_each_entry() instead of the
>>> custom, flawed list iteration code.
>>>
>>> Signed-off-by: Arne Redlich <arne.redlich@xiranet.com>
>>> ---
>>>  drivers/infiniband/ulp/iser/iser_verbs.c |   36 ++++++++++++-----------------
>>>  1 files changed, 15 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
>>> index 714b8db..1c0f968 100644
>>> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
>>> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
>>> @@ -237,33 +237,27 @@ static int iser_free_ib_conn_res(struct iser_conn *ib_conn)
>>>  static
>>>  struct iser_device *iser_device_find_by_ib_device(struct rdma_cm_id *cma_id)
>>>  {
>>> -	struct list_head    *p_list;
>>> -	struct iser_device  *device = NULL;
>>> +	struct iser_device *device;
>>>  
>>>  	mutex_lock(&ig.device_list_mutex);
>>>  
>>> -	p_list = ig.device_list.next;
>>> -	while (p_list != &ig.device_list) {
>>> -		device = list_entry(p_list, struct iser_device, ig_list);
>>> -		/* find if there's a match using the node GUID */
>>> +	list_for_each_entry(device, &ig.device_list, ig_list)
>>>       
>> I've just added the original comments that are missing in your patch.
>>     
>
> Ah well, I probably should've mentioned in the patch description that I
> intentionally removed those comments as I think they're really
> redundant, stating the obvious. But of course I won't insist. :)
>
> Thanks,
> Arne
>   
OK and thanks for catching the bugs.

Roland - will you be able to merge these 2 patches for 2.6.25? Both are
bug fixes.

Thanks,
Erez

