Return-Path: <linux-kernel-owner+w=401wt.eu-S1030274AbXDNNO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030274AbXDNNO1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 09:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030346AbXDNNO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 09:14:27 -0400
Received: from degraaf1.colo.troy.waveform.net ([204.11.33.9]:60910 "HELO
	mahatma.gandhilinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030274AbXDNNO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 09:14:26 -0400
Message-ID: <9457.24.247.238.75.1176556465.squirrel@secure.gandhilinux.org>
In-Reply-To: <20070413191654.1abdbafc.zaitcev@redhat.com>
References: <200704131256.47570.jeremy@jeremya.com>
    <20070413191654.1abdbafc.zaitcev@redhat.com>
Date: Sat, 14 Apr 2007 09:14:25 -0400 (EDT)
Subject: Re: [PATCH] usb bulk transfer: 1024 byte packets
From: "Jeremy C. Andrus" <jeremy@jeremya.com>
To: linux-kernel@vger.kernel.org
Cc: "Pete Zaitcev" <zaitcev@redhat.com>
Reply-To: jeremy@jeremya.com
User-Agent: SquirrelMail/1.4.7
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, April 13, 2007 22:16, Pete Zaitcev wrote:
>
> The transfer size in the URB is not limited by the maximum packet
> size. The HC driver splits up the transfer as specified by URB into
> the required number of packets.

The problem was not in the transfer from PC -> Device, but from Device
-> PC. If I remember correctly, the 512 limit (in the
urb->transfer_flags) is used to setup the DMA. When the device sent
packets which were 1024 bytes in size, the urb came back with a status
set to -EOVERFLOW.

The only place this could happen (in the EHCI) is in qtd_copy_status()
where the hardware has reported a "can't proceed" error (via
QTD_STS_HALT) and then the QTD_STS_BABBLE bit is set (which I interpret
to mean that the device on the other end is "babbling").

[snip]
> I presume the devices didn't show up on your doorstep with baseball
> bats to have a little chat.

In a sense they did when there was no way for me to do BULK transfers
without slamming me with 1024 byte packets :-).

        -Jeremy

-- 
-----------------------
Jeremy C. Andrus
http://www.jeremya.com/
-----------------------

