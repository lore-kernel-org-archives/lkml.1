Return-Path: <linux-kernel-owner+w=401wt.eu-S1946217AbXBIIW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946217AbXBIIW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 03:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946219AbXBIIW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 03:22:58 -0500
Received: from truxi.wincor-nixdorf.com ([217.115.67.78]:34628 "EHLO
	truxi.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946217AbXBIIW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 03:22:58 -0500
Message-ID: <45CC1FA5.3090507@wincor-nixdorf.com>
Date: Fri, 09 Feb 2007 08:15:49 +0100
From: Frank Salomon <frank.salomon@wincor-nixdorf.com>
Reply-To: frank.salomon@wincor-nixdorf.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624 Netscape/7.1
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: EV_MSC / driver/input/input.c (Input Handler)
References: <45CAE5A1.80409@wincor-nixdorf.com> <d120d5000702080715u2902bc81oda4b9250892a1bf2@mail.gmail.com>
In-Reply-To: <d120d5000702080715u2902bc81oda4b9250892a1bf2@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Dmitry Torokhov wrote:

> That is because by default atkbd uses software-emulated raw mode.
> bootk with atkbd.softraw=0 or switch it off after boot through sysfs
> attribute to get EV_MSC/MSC_RAW passed through).

Thank you for your advice, but I really don't know, what will be the 
secondary effect if it will be switched off.

> No, input core should not pass any events device did not claim to support.

I am not sure, but I think the function input_event in 
drivers/input/input.c has 2 tasks:
One is to send events to the device (first part: "switch (type){").

The other one is to send the events to the handler (second part: 
"list_for_each_entry(handle, &dev->h_list, d_node)").

This is the reason why I had the idea of changing the code as I have 
described it before.

With the current implementation, the device sends events to the handler. 
But only events, known/claimed by the device are passed through to the 
handler. I believe, this should be handled transparently.

> What are you trying to do though? Why are you interested in raw atkbd
> events? What will your handler do with events from other input devices
> that might emit raw events?

I have to connected special Point Of Sales Keyboards. Sometimes they are 
sending none standard scan codes, only make codes and no break codes. I 
had successfully implemented this in kernel version 2.4 and now I have 
to do it in 2.6.

Best regards, Frank

