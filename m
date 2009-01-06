Return-Path: <linux-kernel-owner+w=401wt.eu-S1751481AbZAFAjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbZAFAjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbZAFAjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:39:03 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:41022 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZAFAjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:39:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=e/wt78+wJhDOiOP7DQBQG75RCXzSGVYUKJ1WVIINf2N+vyk8QFYAvge1UwLNfF44gA
         5e3j0V9gilF8r4ZCn4jPhktso8SkTnRgJpjgFHOt7zRovoCtC1EwRMV9tVSd4y46kkpZ
         44CKWuPXyDyQopkc5T7r5afCElmH0KoAkx6xk=
Message-ID: <4807377b0901051638r7b31ac62r2165bbe589c04a50@mail.gmail.com>
Date: Mon, 5 Jan 2009 16:38:58 -0800
From: "Jesse Brandeburg" <jesse.brandeburg@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: Intel e1000e: eth0: Detected Tx Unit Hang
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net
In-Reply-To: <1230839773.8319.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230839773.8319.12.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2009 at 11:56 AM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> Dear list,
>
> I just recently observed a strange problem with an onboard 82567LF-2
> Intel ethernet controller. It completely stopped working and this
> desktop machine required a powerdown to get it to work again. This
> happened with 2.6.27.10. However, the machine was working for weeks
> before using an older kernel version (2.6.27.*, no binary modules, intel
> skyburg mainboard, e8400 c2d cpu).
>
> Relevant details follow, can someone make sense of this?

what does cat /proc/interrupts say?

please also include at least ethtool -e eth0 length 256, do you have
the IOMMU enabled?  your full dmesg would let me know.

also, please double check you're running the latest BIOS for your motherboard.

> 00:19.0 Ethernet controller: Intel Corporation 82567LF-2 Gigabit Network Connection
>
> $ dmesg | grep relevant parts
>
> Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
> e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
> 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
> Intel(R) Gigabit Ethernet Network Driver - version 1.2.45-k2
>
> 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) XX:XX:XX:XX:XX:XX
> 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
> 0000:00:19.0: eth0: MAC: 5, PHY: 8, PBA No: ffffff-0ff
> ADDRCONF(NETDEV_UP): eth0: link is not ready
> 0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [...]
> [uptime of a couple of days, with lots of network i/o]
> [...]
> saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> 0000:00:19.0: eth0: Detected Tx Unit Hang:
>  TDH                  <ff>
>  TDT                  <1>
>  next_to_use          <1>
>  next_to_clean        <ff>
> buffer_info[next_to_clean]:
>  time_stamp           <1104ec2c3>
>  next_to_watch        <ff>
>  jiffies              <1104ec8f0>
>  next_to_watch.status <0>

<snip> lots of hangs...

what is the frequency of the hangs?  What kind of traffic are you using?
