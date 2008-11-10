Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYKJKxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYKJKxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 05:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbYKJKx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 05:53:27 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:24840 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbYKJKxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:53:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cP1TsFg5aeEGcBzdK4e/7YJvMj3xxpJDTNCpYhS26BzvQtCGWulEVAJC4shrTihDu+
         1RnppmcBm6mqAhU+ImBT3QvuYAzp2slsZ8Vo/57xQnPDjnbScTkKR7dN43sqwVNznaR0
         jyIasPBgsfBn6A4UY/nHy0Y3gxSE/IbwJ3PK0=
Message-ID: <4918129F.5000106@gmail.com>
Date: Mon, 10 Nov 2008 11:53:19 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0b2YgS8OkbGlu?= <christof.kaelin@gmail.com>
CC: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Mighty mouse (bluetooth) with ID 0x1000 (vendor ID 0x05ac apple)
 any chance for mousewheel?
References: <3d0c012d0811100104o6de42b6er279498eec6781698@mail.gmail.com>
In-Reply-To: <3d0c012d0811100104o6de42b6er279498eec6781698@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2008 10:04 AM, Christof Kälin wrote:
> Hi
> 
> As a newbie, I just saw your email in the source-file when I was looking
> into the sources of hid-apple.c to find my mighty mouse somewhere:
> 
> /* Apple wireless Mighty Mouse */
>         { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 0x030c),
>                 .driver_data = APPLE_MIGHTYMOUSE | APPLE_INVERT_HWHEEL },
> 
> According to hid-ids.h, the ID 0x030c is a TDK mighty mouse. On my
> Alu-iMac (last year edition), it's a Apple's owned mighty mouse (vendor
> 0x05ac, ID 0x1000), which is not currently listed in hid-ids.h. My
> mighty mouse anyway runs o.k. with the "wrong" ID, but since the start
> withouth the mouse-wheel.
> It did not help when I changed the ID's accordingly. So my question is:
> Is there anything to be done in bluetooth driver area too to get this
> mighty mouse fully supported (some quirks needed)?
> 
> Sorry for my annoying questions.
> 
> Thanks in advance for any suggestions and best regards

I guess, they map Z axis to be a wheel instead a wheel be a wheel like in the
0x030c case.

Could you add
{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 0x030c),
  .driver_data = APPLE_MIGHTYMOUSE }
there and
HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 0x030c)
to hid_blacklist in drivers/hid/hid-core.c and try? If the wheel is inverted
with your device, then you need also APPLE_INVERT_HWHEEL aswell.

<me goes to implement new_id like in the PCI case to not bother users with
recompiling the kernel for testing such things>
