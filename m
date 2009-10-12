Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbZJLWyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbZJLWyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbZJLWyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:54:24 -0400
Received: from radagast.issp.eu ([86.59.99.45]:47105 "EHLO radagast.issp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbZJLWyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:54:23 -0400
Message-ID: <20091013005346.95254r0nd1pw97s4@www.kundendienste.net>
Date: Tue, 13 Oct 2009 00:53:46 +0200
From: lkml@makubi.at
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: arndbergmann@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: DHCP and iptables
References: <20091012235013.16174ciovvwpw70g@www.kundendienste.net>
 <4AD3B1A6.10508@zytor.com>
In-Reply-To: <4AD3B1A6.10508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On 10/12/2009 02:50 PM, lkml@makubi.at wrote:
>> Well, I just looked for "ethernet protocol" and read some things about
>> DHCP again.
>>
>> What's an ethernet protocol?
>>
>> I also read, that "DHCP is built directly on UDP and IP" (RFC 2131).
>>
>> It uses Ports (UDP 67/68) and the source address of the DHCP server is
>> an IP address.
>>
>> Could you answer me more in detail, why I get an IP, but block
>> everything with iptables?
>>
>
> The reason is that the DHCP client bypasses the Linux IP stack
> completely (because it has special requirements.)
>
>> |   |   DHCP is an ethernet protocol, not an IP protocol, so you have to use
>> |   |   ebtables instead of iptables to filter it.
>> |   |
>> |   |   	Arnd <><
>
> This is actually incorrect -- DHCP is an IP (UDP, in fact) protocol.  It
> just has very special requirements (such as being able to use
> src=0.0.0.0 dst=255.255.255.255) that aren't needed in normal operation,
> so rather than slowing down the in-kernel IP stack it synthesizes raw
> packets.
>
> 	-hpa
>

So iptables uses the in-kernel IP stack and because of that fact, it  
is not able to filter the DHCP packets?

