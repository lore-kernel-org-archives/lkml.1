Return-Path: <linux-kernel-owner+w=401wt.eu-S933243AbZJLWql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243AbZJLWql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932730AbZJLWqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:46:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57160 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbZJLWqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:46:40 -0400
Message-ID: <4AD3B1A6.10508@zytor.com>
Date: Mon, 12 Oct 2009 15:45:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: lkml@makubi.at
CC: arndbergmann@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: DHCP and iptables
References: <20091012235013.16174ciovvwpw70g@www.kundendienste.net>
In-Reply-To: <20091012235013.16174ciovvwpw70g@www.kundendienste.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2009 02:50 PM, lkml@makubi.at wrote:
> Well, I just looked for "ethernet protocol" and read some things about  
> DHCP again.
> 
> What's an ethernet protocol?
> 
> I also read, that "DHCP is built directly on UDP and IP" (RFC 2131).
> 
> It uses Ports (UDP 67/68) and the source address of the DHCP server is  
> an IP address.
> 
> Could you answer me more in detail, why I get an IP, but block  
> everything with iptables?
> 

The reason is that the DHCP client bypasses the Linux IP stack
completely (because it has special requirements.)

> |   |   DHCP is an ethernet protocol, not an IP protocol, so you have to use
> |   |   ebtables instead of iptables to filter it.
> |   |
> |   |   	Arnd <><

This is actually incorrect -- DHCP is an IP (UDP, in fact) protocol.  It
just has very special requirements (such as being able to use
src=0.0.0.0 dst=255.255.255.255) that aren't needed in normal operation,
so rather than slowing down the in-kernel IP stack it synthesizes raw
packets.

	-hpa
