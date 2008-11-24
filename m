Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYKXPCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYKXPCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYKXPCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:02:08 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:2520 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750935AbYKXPCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:02:07 -0500
Message-ID: <492AC1ED.30104@ru.mvista.com>
Date: Mon, 24 Nov 2008 18:02:05 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
Subject: Re: [patch v2.6.28-rc6-28-g5bcdadf 6/7] usb: musb: use list_is_last
References: <1227524813-27528-1-git-send-email-felipe.balbi@nokia.com> <1227524813-27528-2-git-send-email-felipe.balbi@nokia.com> <1227524813-27528-3-git-send-email-felipe.balbi@nokia.com> <1227524813-27528-4-git-send-email-felipe.balbi@nokia.com> <1227524813-27528-5-git-send-email-felipe.balbi@nokia.com> <1227524813-27528-6-git-send-email-felipe.balbi@nokia.com> <1227524813-27528-7-git-send-email-felipe.balbi@nokia.com> <492AB11E.8050109@ru.mvista.com> <20081124145734.GD7476@gandalf.research.nokia.com>
In-Reply-To: <20081124145734.GD7476@gandalf.research.nokia.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi wrote:

>>>diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
>>>index d6a802c..b6aea0b 100644
>>>--- a/drivers/usb/musb/musb_gadget.c
>>>+++ b/drivers/usb/musb/musb_gadget.c
>>>@@ -1159,7 +1159,7 @@ static int musb_gadget_queue(struct usb_ep *ep, struct usb_request *req,
>>> 	list_add_tail(&(request->request.list), &(musb_ep->req_list));
>>>  	/* it this is the head of the queue, start i/o ... */
>>>-	if (!musb_ep->busy && &request->request.list == musb_ep->req_list.next)
>>>+	if (!musb_ep->busy && list_is_last(&request->request.list, &musb_ep->req_list))
>>
>>   This is not the same -- the replaced comparison checked if the request is
>>first in queue, not last. Look at the definition of that function:

> Good catch. Greg, please drop this patch.

    BTW, it's strange that there's list_is_last() but no list_is_first()...

WBR, Sergei
