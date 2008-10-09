Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbYJISrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbYJISrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbYJISre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:47:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44027
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753407AbYJISrd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:47:33 -0400
Date: Thu, 09 Oct 2008 11:47:09 -0700 (PDT)
Message-Id: <20081009.114709.102722304.davem@davemloft.net>
To: rvsjoen@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: NAPI enabled driver (tg3) silent packet loss ?
From: David Miller <davem@davemloft.net>
In-Reply-To: <efa8e58e0810091053s4b1d25b7u621ee92be84d2041@mail.gmail.com>
References: <efa8e58e0810091053s4b1d25b7u621ee92be84d2041@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rune V. Sjøen" <rvsjoen@gmail.com>
Date: Thu, 9 Oct 2008 19:53:45 +0200

[ netdev@vger.kernel.org is the place to discuss networking
  things ]

> I am sending frames to a host using, all the frames are accounted for
> in the rx_ucast_packets counter of the device.
> However the application shows a substantial packet loss. I assume that
> the rx_ucast_packets counter is incremented when the frame is received
> and then it is put into the ring buffer. I am having a hard time
> figuring out where these packets are lost, and my suspicion lies with
> the NAPI enabled tg3.
> 
> If the ring buffer overflows will the driver overwrite/drop packets
> without incrementing any counters ? That would explain why the packets
> are counted as received and then lost (by not being passed to the next
> layer).

No, the generic device dropped counter will increment, or the
device specific RX ring full condition will be indicated.

You can also check if the networking stack itself is dropping
the packet, using netstat -s and friends.
