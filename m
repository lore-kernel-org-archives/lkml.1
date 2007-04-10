Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbXDJLCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbXDJLCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbXDJLCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:02:04 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:22370 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbXDJLB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:01:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=BPvA3f4PIJa3OUElh6yisf5LPMLOB2JK6Y9DyzJj7RPjp+gz1wIC0MRH+co//dA+FhKNTAd4gGTJat/i5k0CzjIMO0n0zHxGBadLOCjfLDg9PUD2+A/kkZUgUQsHw589O8iMNKZTe/Oyf7/fcFVuszc0UwtJ8yLa/WbKoX6P3BY=
Message-ID: <461B6E4C.70008@gmail.com>
Date: Tue, 10 Apr 2007 19:00:28 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Li Yu <raise.sail@gmail.com>, hongzhiyi@ccoss.com.cn,
       yanghong@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] HID bus prototype - 20070408
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com>	<1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn>	<Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>	<d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>	<1175516515.5815.347.camel@violet>	<Pine.LNX.4.64.0704021429420.3808@jikos.suse.cz>	<1175532439.5815.375.camel@violet> <4611AAC1.8050303@gmail.com>	<Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz>	<02f801c7770d$3eafb050$84163e05@kroptech.com>	<Pine.LNX.4.64.0704050109500.4173@jikos.suse.cz>	<036401c77711$cee286d0$84163e05@kroptech.com>	<46189FE3.6050206@gmail.com> <Pine.LNX.4.64.0704101136330.13232@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0704101136330.13232@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> Hi Li,
>
> we have been discussing this with Marcel previously, and the decission was 
> to let the hidp code where it is right now, due to it being very closely 
> connected to the bluetooth network stack.
>   
That's OK.
>   
>> 	1. HID/Bluetooth support, ONLY FOR HIGHLY EXPERIMENT. I have no 
>>          any such device to test yet.
>>     
>
> I didn't have time yet to review the patch you sent previously, but I 
> don't still quite understand why does the transport layer matter here? The 
> generic HID layer, as it is in kernel now, makes an abstraction in a way 
> that the HID-specific drivers should not care about the underlying 
> transport layer.
>
>   
Here is my reason for supply such hid_transport data structure:

As before, we only have one driver for each transport layer, IOW, the
common driver. In this case, we really need not such transport data
structure. However, there are many driver in one transport layer after
HID bus come, these drivers at the same transport layer implementation
would like share some something each other, these live in common driver
before. If we did not add such transport data structure, we must find
one related driver, and clone it, I think that is not good idea.

In fact, even now, the HID processing logic still do not take care of
which transport layer works under it, the cost just is increasing some
pointer reference operations.

>> 	I am sorry for it is not in patch form.
>>     
>
> That's quite unfortunate. I'll try to review it nevertheless, but it'd be 
> much more convenient if you manage to send a patch.
>
>   
OK, I will post the patch for 2.6.21-rc6-mm1 later. You are recommended
to wait to review that.

My friend yanghong buy a new bluetooth mouse, so I can test bluetooth
nowadays, Thanks him here. :D

Good luck.

- Li Yu

