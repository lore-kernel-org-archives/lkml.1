Return-Path: <linux-kernel-owner+w=401wt.eu-S1764911AbYCDPlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764911AbYCDPlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYCDPli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:41:38 -0500
Received: from mail.tnp-online.de ([212.80.247.147]:56575 "EHLO
	relay1.gigamail.to" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYCDPlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:41:37 -0500
From: Arne Redlich <arne.redlich@xiranet.com>
To: Erez Zilber <erezz@voltaire.com>
Cc: Roland Dreier <rolandd@cisco.com>,
       ofa-general <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] IB/iSER: fix list iteration bug
References: <877igkxffl.fsf@confield.dd.xiranet.com>
	<47CD3B7A.2010106@voltaire.com>
Date: Tue, 04 Mar 2008 16:41:20 +0100
In-Reply-To: <47CD3B7A.2010106@voltaire.com> (Erez Zilber's message of "Tue,
	04 Mar 2008 14:07:22 +0200")
Message-ID: <878x0yfqe7.fsf@confield.dd.xiranet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-xiranet-MailScanner-OpenProtect-Information: Please contact the ISP for more information
X-xiranet-MailScanner-OpenProtect: Found to be clean
X-xiranet-MailScanner-OpenProtect-MCPCheck: 
X-xiranet-MailScanner-OpenProtect-From: arne.redlich@xiranet.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zilber <erezz@voltaire.com> writes:

> Arne Redlich wrote:
>> The iteration through the list of "iser_device"s during device
>> lookup/creation is broken - it might result in an infinite loop if more
>> than 1 HCA is used with iSER. Use list_for_each_entry() instead of the
>> custom, flawed list iteration code.
>> 
>> Signed-off-by: Arne Redlich <arne.redlich@xiranet.com>
>> ---
>>  drivers/infiniband/ulp/iser/iser_verbs.c |   36 ++++++++++++-----------------
>>  1 files changed, 15 insertions(+), 21 deletions(-)
>> 
>> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
>> index 714b8db..1c0f968 100644
>> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
>> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
>> @@ -237,33 +237,27 @@ static int iser_free_ib_conn_res(struct iser_conn *ib_conn)
>>  static
>>  struct iser_device *iser_device_find_by_ib_device(struct rdma_cm_id *cma_id)
>>  {
>> -	struct list_head    *p_list;
>> -	struct iser_device  *device = NULL;
>> +	struct iser_device *device;
>>  
>>  	mutex_lock(&ig.device_list_mutex);
>>  
>> -	p_list = ig.device_list.next;
>> -	while (p_list != &ig.device_list) {
>> -		device = list_entry(p_list, struct iser_device, ig_list);
>> -		/* find if there's a match using the node GUID */
>> +	list_for_each_entry(device, &ig.device_list, ig_list)
>
> I've just added the original comments that are missing in your patch.

Ah well, I probably should've mentioned in the patch description that I
intentionally removed those comments as I think they're really
redundant, stating the obvious. But of course I won't insist. :)

Thanks,
Arne
