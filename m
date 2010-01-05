Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964Ab0AEWRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab0AEWRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477Ab0AEWRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:17:41 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:47793 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab0AEWRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:17:40 -0500
Message-ID: <4B43B989.4010004@nortel.com>
Date: Tue, 05 Jan 2010 16:13:29 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mst@redhat.com, eric.dumazet@gmail.com, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: packet: option to only pass skb protocol
References: <20100105185732.GA30346@redhat.com>	<4B43AEF6.6050701@nortel.com> <20100105.134218.258781374.davem@davemloft.net>
In-Reply-To: <20100105.134218.258781374.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jan 2010 22:17:35.0577 (UTC) FILETIME=[E2223490:01CA8E54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 03:42 PM, David Miller wrote:
> From: "Chris Friesen" <cfriesen@nortel.com>
> Date: Tue, 05 Jan 2010 15:28:22 -0600
> 
>> On 01/05/2010 12:57 PM, Michael S. Tsirkin wrote:
>>> When sending packets with a packet socket it is often necessary to set
>>> protocol in msg_name: otherwise the protocol field in the skb will not
>>> be set correctly.
>>
>> What about automatically detecting the protocol from the data being sent
>> to avoid the necessity of specifying it in the first place?
> 
> This limits packet socket usage to only protocols the kernel is aware
> of, defeating part of the usefulness of the packet socket facility.

I don't follow.

If SOCK_RAW packets are being sent, the protocol number is embedded in
the packet data and the kernel should be able to extract it regardless
of whether the kernel actually supports it or not.  I see that Michael
just posted a patch for this.

If SOCK_DGRAM packets are being sent, then I agree that the app needs to
pass it down at send time or at bind() time to support protocols of
which the kernel is not aware.

While looking at the code I noticed that while the protocol number is
validated at socket creation time it does not appear to be validated for
calls to bind() for packet sockets.  Is this intentional?

As a further question, does it actually make sense to check the protocol
number at packet socket creation?  It seems like we should be able to
allow a packet socket to specify arbitrary protocol numbers since the
kernel doesn't really need to do anything with them.

Chris
