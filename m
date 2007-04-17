Return-Path: <linux-kernel-owner+w=401wt.eu-S1031042AbXDQBEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031042AbXDQBEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 21:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031043AbXDQBEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 21:04:16 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:8352 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031042AbXDQBEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 21:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=OvU3EC6Gv5oO12h7vPC7BtscKwUGL8ZN+6IembRcm31lgvIRd6vbYDsdsvA43uKNCQhFblHI6bzC5E9cvMFhtgxBUCq5p1suZ6EyWhNFGJfSNw+Wfmeg9jYVMZNDqG5rfqF/awks1aGTr97x5GfPi025hsE1pNWAr2wJpFly6Gw=
Message-ID: <46241CCF.2000707@gmail.com>
Date: Tue, 17 Apr 2007 09:03:11 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Li Yu <raise.sail@gmail.com>,
       =?ISO-8859-1?Q?=3F=3F=3F?= <hongzhiyi@ccoss.com.cn>,
       =?ISO-8859-1?Q?=3F=3F?= <yanghong@ccoss.com.cn>,
       Marcel Holtmann <marcel@holtmann.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] hid: hid bus prototype 20070416
References: <46230EDE.5020300@gmail.com> <alpine.LSU.0.98.0704161504280.18903@jikos.suse.cz>
In-Reply-To: <alpine.LSU.0.98.0704161504280.18903@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Mon, 16 Apr 2007, Li Yu wrote:
>
>   
>> HID bus prototype 20070416
>>     
>
> Hi Li,
>
> thanks for taking care. Well, the patch is quite huge, do you think you 
> could split it into separate independent parts (use quilt or something 
> similar for patch management) which could be reviewed independently?
>
> As the code changes are often quite non-trivial, layering is changed, 
> lots of files are touched, etc. it would help a lot.
>
>   
OK, I must be next.
> Notes from a quick skim through the patch:
>
> - it seems that you accidentaly deleted the newly added quirk for
>    mightymouse in the bluetooth hid code?
>   

They should be lost while I play bluetooth.
> - what is the point behind HID_QUIRK_SKIP? Why doesn't HID_QUIRK_IGNORE
>    suffice? And why is it defined in so strange way:
>
> @@ -270,6 +271,7 @@ struct hid_item {
>   #define HID_QUIRK_LOGITECH_DESCRIPTOR          0x00100000
>   #define HID_QUIRK_DUPLICATE_USAGES             0x00200000
>   #define HID_QUIRK_RESET_LEDS                   0x00400000
> +#define HID_QUIRK_SKIP                         0x80000000
>
>   
I am sorry for missing some description here. In simple words, the
HID_QUIRK_IGNORE let usbhid do not register some hid devices at all,
however, the HID_QUIRK_SKIP just let usbhid skip matching with the
device which is marked that quirk, but still register this kind of hid
device. So another HID driver still handle have chances to handle it.
You can discover out there, the hid-core.c is not pure HID driver, it
also take the transports role here.

I think this quirk have such difference with others, so I define it so.
If we do like so, just change it. That is OK.

May be, we need another hid_skiplist[] ?

> - there are bunches of some easy codingstyle issues (spaces around '=',
>    etc)
>
>   
Yes, This is one of reasons for it is only for review.
> But doing really thorough review is quite hard, as the patch contains lots 
> of unrelated changes. I'll look at it a little bit more, but when you send 
> a broken-out version with separate changes, that'd be great.
>
>   
OK.
> Thanks,
>
>   

