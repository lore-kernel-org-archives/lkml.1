Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbXC1B7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbXC1B7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 21:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933403AbXC1B7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 21:59:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:44769 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075AbXC1B7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 21:59:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=H959UbRr/0b8fe98X1rjM7OoyijkMA77CdBbtT7Ivny4qSj7ObiF4nHSLNR0KCkXmAoRZAMj4HKfCchtd0ppYwjd///oBtcaRzR0KftjQYyEY311hgA2OMc7ZFx8Sj92FDKZHF9aOaGwoTOpLyH5bSWH7yknEwF/zyOm5fz9KNc=
Message-ID: <4609CBC5.4080208@gmail.com>
Date: Wed, 28 Mar 2007 09:58:29 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Li Yu <raise.sail@gmail.com>, hongzhiyi@ccoss.com.cn,
       Jiri Kosina <jkosina@suse.cz>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       yanghong@ccoss.com.cn, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
References: <200703051532096508636@gmail.com>  <45FE6971.6090503@gmail.com> <1174897676.5815.6.camel@violet>
In-Reply-To: <1174897676.5815.6.camel@violet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> please don't take the transport layers into account when designing the
> HID bus. They have nothing to do with the upper layer. Especially the
> upper layer shouldn't care at all if the actual HID reports are sent
> over USB or Bluetooth.
>
>   
I am sorry for I see this mail so later.

I also sense this. we may need not such a complete layer at all. Although the work of hiddev/rawdev support does not begin, however, as the design, especially, let hiddev/rawdev live in HIDAL, I think this may need a bit of abstract of transport layer.

> The transport drivers (usbhid and hidp) will only communicate with the
> HID core and for the bus it makes no difference. The current abstraction
> for HID transports works pretty fine and there is no need to change
> this.
>
>   
Nod. HIDAL should not care which transport layer works under it. if so, that is not HIDAL, that is HIDBL(HID Branch instruction Layer) instead of. :D

> I think that a HID bus driver should be able register to a specific HID
> report for a specific device. This would allow to have a generic driver
> that can handle all common keyboard and mouse functionality and then in
> addition a specific driver that handles vendor specific reports. It
> might also make sense to let the driver match on specific HUT codes.
>
>   
In current development implementation, the match process still can work in traditional Vendor ID/Product ID way, but it do not reject other means. If the author of driver hope to match for specific HID report, just do it. In fact, the HIDAL only know the result of match process, not how to do it.I think your "generic driver" is same with my "fundamental driver", and "specific driver" is same with "shadow driver" too.

Er, What's mean of your "HUT", HID Usage Table? if so, I think I have already explained we can do it.However, we should supply some convenient API for this work. or HIT is other mysterious thing? ;)

> Regards
>
> Marcel
>
>
>   
Progress: It seem the shadow basic support works! but It still need more tests.

Good luck.

- Li Yu

