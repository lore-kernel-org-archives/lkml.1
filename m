Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbYJFLWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbYJFLWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 07:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYJFLVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 07:21:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:44526 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbYJFLVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 07:21:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,367,1220252400"; 
   d="scan'208";a="623822631"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] btsdio: fix tx error path
Date: Mon, 6 Oct 2008 13:20:35 +0200
Message-ID: <C07C4589BE74A34981C3C3525EE1F801048A149D@hasmsx412.ger.corp.intel.com>
In-Reply-To: <1223290490.11272.149.camel@violet.holtmann.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] btsdio: fix tx error path
Thread-Index: AcknogjAO7piu7TcShKiwrNwUsKjOAAAgxtQ
References: <1223283914-18238-1-git-send-email-tomas.winkler@intel.com> <1223290490.11272.149.camel@violet.holtmann.net>
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Cc: <linux-bluetooth@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 Oct 2008 11:20:38.0858 (UTC) FILETIME=[8F9232A0:01C927A5]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Marcel Holtmann [mailto:marcel@holtmann.org]
>Sent: Monday, October 06, 2008 12:55 PM
>To: Winkler, Tomas
>Cc: linux-bluetooth@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] btsdio: fix tx error path
>
>Hi Tomas,
>
>> This patch fixes accumulating of the header
>> in case packet was requeued in the error path.
>>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> Cc: Marcel Holtmann <marcel@holtmann.org>
>> ---
>>  drivers/bluetooth/btsdio.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
>> index 58630cc..e4724b8 100644
>> --- a/drivers/bluetooth/btsdio.c
>> +++ b/drivers/bluetooth/btsdio.c
>> @@ -91,6 +91,7 @@ static int btsdio_tx_packet(struct btsdio_data
*data,
>struct sk_buff *skb)
>>
>>  	err = sdio_writesb(data->func, REG_TDAT, skb->data, skb->len);
>>  	if (err < 0) {
>> +		skb_pop(skb, 4);
>>  		sdio_writeb(data->func, 0x01, REG_PC_WRT, NULL);
>>  		return err;
>>  	}
>
>please do at least a compile test. It is skb_pull() and not skb_pop().

Sorry, my bad. It was oneliner so I didn't take the patch directly from
the test machine and my server .config was wrong so the file didn't
compile at all :( leading to clean compilation I will resubmit be more
careful next time. 

Tomas 

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

