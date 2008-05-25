Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbYEYS2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbYEYS2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbYEYS2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:28:19 -0400
Received: from senator.holtmann.net ([87.106.208.187]:36772 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbYEYS2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:28:18 -0400
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
Message-Id: <5020127D-136C-4CFD-83D3-A6C832A97552@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200805252018.58627.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 20:28:13 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211722835.17151.24.camel@johannes.berg> <3B90BEFD-148C-47DF-9437-500109907976@holtmann.org> <200805252018.58627.mb@bu3sch.de>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

>> So you actually do know how request_firmware() actually works right
>> now? You need to change the firmware_class implementation and API to
>> give it an extra parameter to allow any kind if simultaneous loading
>> within one driver. Having the FIRMWARE as environment variable is
>> actually suboptimal. You want to have the FIRMWARE environment
>> variable as bus_id for the firmware struct device object.
>
> Can you explain _why_ we want to have this as bus_id?
> I don't really understand that.

we want to avoid duplicate sysfs entries. And with multi-function  
devices like in SDIO this can happen that the actual sysfs device  
entry becomes the same and then the struct device creation for the  
second firmware loading fails (if the first one hasn't finished).  
Putting the actually firmware filename as bus_id allows us to  
distinguish between the different firmware loading tasks.

With the remove of class devices and the more complex multi-function  
devices we have to make the firmware loading fully race free. If not  
we end up with sleep(1) hacks around everything and we don't want that.

Regards

Marcel

