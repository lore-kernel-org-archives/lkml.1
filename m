Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbXDBHIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbXDBHIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbXDBHIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:08:48 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:40185 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbXDBHIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=hwoex5aD/T1/FzxO299kOQRwytw2iNSqLS71uOC310QoKq/w8Lq6SdMaBMRInb/8ffssu0kmAUFD/RP+nfPWkkYHSJfR5K4VHjGl5iNamDmjoO3kLAA0kS1l8GYmVB/zhFXUkAYqQ4FbgPdykb7+n0eOdD98RfK0C7XjbUeuGMc=
Message-ID: <4610ABB1.3080606@gmail.com>
Date: Mon, 02 Apr 2007 15:07:29 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: Li Yu <raise.sail@gmail.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Jiri Kosina <jkosina@suse.cz>,
       Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
References: <200703051532096508636@gmail.com>	<Pine.LNX.4.64.0704010002280.6040@jikos.suse.cz>	<4610609C.9030101@gmail.com> <200704020015.44167.dtor@insightbb.com>
In-Reply-To: <200704020015.44167.dtor@insightbb.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
>
> No, please don't do that. As soon as there is a special driver written
> for a device that device's VID/PID should be added to generic HID
> blacklist. This way udev will load the proper driver right away and
> there will not be any flip-flopping of input devices. 
>   
Hi, I do not think that using blacklist in base driver for this purpose
is good idea. If so, we need modify source when each new HID device
driver come, that's so ugly. I think the blacklist only should be used
for those really broken/buggy hardware, not for these normal hardware
with extended feature.

Er, I also want to know what are drawbacks of "flip-flopping" ?


>  
>   
>> When user A remove this shadow driver, the USB/base driver should resume
>> work for this joystick, IOW, it should register back its input device again.
>>
>>     
>
> Why would we want to revert to using generic HID's implementation if we
> know that it is broken for that particular device???
>
>   

Well, many devices just only can not play its full feature, not broken.
so base driver still can work for us.
