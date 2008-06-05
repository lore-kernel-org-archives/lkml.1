Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbYFEPFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbYFEPFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759324AbYFEPE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:04:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:38424 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759300AbYFEPEz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:04:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=rlxW7NpEig96XxiQb7cCt2Xta3rKWbQR5TUFYf/8c9TyXKYBC8dB1VPha1/T65Pbnk
         id9Eq10cte7hMvGTJKolKnNU16P/xcJGXx+VHKyoImEgWe8upGSHXzxDtAVBmIiqegzR
         VNS1EmAmDZnlN6wS1JxuUwckzEsYd+MwPVL0k=
Message-ID: <a5bf86a80806050804n4059fd1do54b042e918b50efe@mail.gmail.com>
Date: Thu, 5 Jun 2008 18:04:51 +0300
From: "Lior Dotan" <liodot@gmail.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       ariveira@gmail.com
Subject: Re: Linux 2.6.26-rc5
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2008 16:03, Alejandro Riveira Fernández wrote:
> El Wed, 4 Jun 2008 20:36:24 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> escribió:
>
>> Another week, another batch of mostly pretty small fixes. Hopefully the
>> regression list is shrinking, and we've fixed at least a couple of the
>> oopses on Arjan's list.
>>
>  I got this on my dmesg; is this expected/harmaless?
>  (btw The wireless driver oops that i reported is gone as it is the
>  bluetooth one ;)
>
> [    0.232963] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
> [    0.233020] system 00:08: ioport range 0x4000-0x40bf could not be reserved
> [    0.233075] system 00:08: ioport range 0x40c0-0x40df has been reserved
> [    0.233131] system 00:08: ioport range 0x400-0x40f has been reserved
> [    0.233186] system 00:08: ioport range 0x480-0x48f has been reserved
> [    0.233243] system 00:08: iomem range 0xfff80000-0xffffffff could not be reserved
> [    0.233694] system 00:08: iomem range 0xfec10000-0xfec10fff has been reserved
> [    0.233750] system 00:08: iomem range 0xfe000000-0xfe0000ff has been reserved
>
I also got these after upgrading from 2.6.25.4 and also these messages:
Jun  5 16:26:58 ps3 [   20.763385] AER service couldn't init device
0000:00:02.0:pcie01 - no _OSC support
Jun  5 16:26:58 ps3 [   20.763385] AER service couldn't init device
0000:00:03.0:pcie01 - no _OSC support
Jun  5 16:26:58 ps3 [   20.763385] AER service couldn't init device
0000:00:04.0:pcie01 - no _OSC support
Jun  5 16:26:58 ps3 [   20.763385] AER service couldn't init device
0000:00:05.0:pcie01 - no _OSC support
Jun  5 16:26:58 ps3 [   20.763385] AER service couldn't init device
0000:00:06.0:pcie01 - no _OSC support
Jun  5 16:26:58 ps3 [   20.763385] AER service couldn't init device
0000:00:07.0:pcie01 - no _OSC support

The devices are:
00:02.0 0604: 8086:25f7 (rev b1)
00:03.0 0604: 8086:25e3 (rev b1)

In addition, /dev/rtc was missing until I disabled CONFIG_RTC_CLASS
and enabled CONFIG_RTC in device drivers -> character devices. It was
enabled in the old 2.6.25 config file which I copied over to 2.6.26
and did a make oldconfig.

Cheers,
Lior.
