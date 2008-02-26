Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbYBZDNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbYBZDNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYBZDNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:13:45 -0500
Received: from senator.holtmann.net ([87.106.208.187]:41126 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYBZDNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:13:44 -0500
Cc: Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Message-Id: <2FF12C41-8390-4D3A-B1B2-25F3D21FB580@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Quel Qun <kelk1@comcast.net>
In-Reply-To: <022620080003.1247.47C35750000085C8000004DF2207300793CE05040A05@comcast.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: Kernel oops with bluetooth usb dongle
Date: Tue, 26 Feb 2008 04:13:39 +0100
References: <022620080003.1247.47C35750000085C8000004DF2207300793CE05040A05@comcast.net>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Quel,

> -------------- Original message ----------------------
> From: Thomas Gleixner <tglx@linutronix.de>
>> On Fri, 22 Feb 2008, David Woodhouse wrote:
>>
>>> On Fri, 2008-02-22 at 08:23 +0100, Thomas Gleixner wrote:
>>>>
>>>> +       del_timer(&conn->info_timer);
>>>> +
>>>>        hcon->l2cap_data = NULL;
>>>>        kfree(conn);
>>>
>>> Shouldn't that be del_timer_sync() ?
>>
>> Hmm, probably yes.
>>
> Hi,
>
> Great news: only adding adding del_timer_sync() to 2.6.25-rc3 does  
> prevent the crash.
>
> Bad news: I still cannot use the device.
>
> hcitool inq, hcitool scan, hcitool name <btaddr> and hcitool info  
> <btaddr>
> commands work.
>
> hcitool cc <btaddr>, sdptool <btaddr>, rfcomm connect command fail,  
> most of them
> with a 'Connection reset by peer' error.

what does "hciconfig hci0 version" tell you about your device? Some of  
the none major based Bluetooth chips are broken and might need an  
extra tweak within the USB driver.

Regards

Marcel

