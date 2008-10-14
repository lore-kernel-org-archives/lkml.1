Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYJNIzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYJNIzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbYJNIzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:55:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57876 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbYJNIzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:55:22 -0400
Message-ID: <015c01c92dda$1b754340$LocalHost@wipultra1303>
From: "Madhusudhan Chikkature" <madhu.cr@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <gadiyar@ti.com>, <johnpol@2ka.mipt.ru>, <linux-kernel@vger.kernel.org>,
       <linux-omap@vger.kernel.org>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF0@dbde02.ent.ti.com><20081010133845.8b82fac3.akpm@linux-foundation.org><062801c92d37$3413bdd0$LocalHost@wipultra1303> <20081013085323.f8bd7efb.akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] HDQ Driver for OMAP2430/3430
Date: Tue, 14 Oct 2008 14:21:50 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----- 
From: "Andrew Morton" <akpm@linux-foundation.org>
To: "Madhusudhan Chikkature" <madhu.cr@ti.com>
Cc: <gadiyar@ti.com>; <johnpol@2ka.mipt.ru>; <linux-kernel@vger.kernel.org>; <linux-omap@vger.kernel.org>
Sent: Monday, October 13, 2008 9:23 PM
Subject: Re: [PATCH 1/5] HDQ Driver for OMAP2430/3430


>> On Mon, 13 Oct 2008 18:55:43 +0530 "Madhusudhan Chikkature" <madhu.cr@ti.com> wrote:
>> 
>> ----- Original Message ----- 
>> From: "Andrew Morton" <akpm@linux-foundation.org>
>> To: "Gadiyar, Anand" <gadiyar@ti.com>
>> Cc: <johnpol@2ka.mipt.ru>; <linux-kernel@vger.kernel.org>; <linux-omap@vger.kernel.org>; <madhu.cr@ti.com>
>> Sent: Saturday, October 11, 2008 2:08 AM
>> Subject: Re: [PATCH 1/5] HDQ Driver for OMAP2430/3430
>> 
>> 
>> >> +       /* set the GO bit */
>> >> +       hdq_reg_merge(hdq_data, OMAP_HDQ_CTRL_STATUS, OMAP_HDQ_CTRL_STATUS_GO,
>> >> +               OMAP_HDQ_CTRL_STATUS_DIR | OMAP_HDQ_CTRL_STATUS_GO);
>> >> +       /* wait for the TXCOMPLETE bit */
>> >> +       ret = wait_event_interruptible_timeout(hdq_wait_queue,
>> >> +               hdq_data->hdq_irqstatus, OMAP_HDQ_TIMEOUT);
>> >> +       if (ret < 0) {
>> >> +               dev_dbg(hdq_data->dev, "wait interrupted");
>> >> +               return -EINTR;
>> >> +       }
>> > 
>> > Is this desirable?  The user hits ^C and the driver bails out?
>> > 
>> > I assume so, but was this tested?
>> 
>> Andrew, What is the test scenario you mean here? A user hitting ^C when the driver is waiting for the TXCOMPLETE bit?
> 
> Yes.
> 

Yes. It is desired to return an error if the condition in the wait is not met. I need to change the check for return value to check for zero and neg value.

I spent some time to test this perticular scenario.I could not really see any impact of hitting ^C when an application is 
transfering data in the background. When the h/w is programmed to transfer data and the driver issues a wait, I see that 
TXCOMPLETE interrupt comes immediately and wakes up as expected. 

So guess I am unable to hit ^C exactly when the driver is waiting in wait_event_interruptible_timeout(before the condition 
is met) for it to catch the signal. Is it generally suggested to use wait_event_timeout so that ^C signal is not caught?

Regards,
Madhu
