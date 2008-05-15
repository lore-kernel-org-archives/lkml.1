Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbYEOID5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbYEOID5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 04:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbYEOIDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 04:03:41 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:59074 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbYEOIDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 04:03:39 -0400
X-IronPort-AV: E=Sophos;i="4.27,490,1204520400"; 
   d="scan'208";a="68342637"
Message-ID: <482BEE57.6040704@analog.com>
Date: Thu, 15 May 2008 16:03:35 +0800
From: Jie Zhang <jie.zhang@analog.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Bryan Wu <cooloney@kernel.org>, harvey.harrison@gmail.com,
       david-b@pacbell.net, greg@kroah.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [usb/host]: use get/put_unaligned_* helpers to fix
 more potential unaligned issues.
References: <1210832364-20012-1-git-send-email-cooloney@kernel.org> <200805150940.34516.oliver@neukum.org>
In-Reply-To: <200805150940.34516.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2008 08:03:34.0428 (UTC) FILETIME=[2C2D5DC0:01C8B662]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Donnerstag 15 Mai 2008 08:19:24 schrieb Bryan Wu:
>> --- a/drivers/usb/host/uhci-hub.c
>> +++ b/drivers/usb/host/uhci-hub.c
>> @@ -253,7 +253,7 @@ static int uhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
>>         switch (typeReq) {
>>  
>>         case GetHubStatus:
>> -               *(__le32 *)buf = cpu_to_le32(0);
>> +               put_unaligned_le32(0, buf);
> 
> What is supposed to make all these changes a good idea?
> 
Since buf might not be 4-byte aligned.


Jie
