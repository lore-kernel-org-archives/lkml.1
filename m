Return-Path: <linux-kernel-owner+w=401wt.eu-S933465AbZJLWJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465AbZJLWJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbZJLWJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:09:39 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:32978 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455AbZJLWJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Fi0uPfRoMD6vnQ1ziw39JwUajm6NSdnSQfQ+MYh0Lg54/zGe3uZFeciggTantUI4Io
         BoONkxAna5f6jNvzkSGGHkbw3NQlan2woHKSyVqd5Rhmmi3CwD5QX/xge2eXbbzdykIC
         04TcZn6lCYgIefNWN3vmLgy7QAR7cSQ7/SF4k=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: lkml@makubi.at
Subject: Re: DHCP and iptables
Date: Tue, 13 Oct 2009 00:08:57 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: arndbergmann@googlemail.com, linux-kernel@vger.kernel.org
References: <20091012235013.16174ciovvwpw70g@www.kundendienste.net>
In-Reply-To: <20091012235013.16174ciovvwpw70g@www.kundendienste.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910130008.57174.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, lkml@makubi.at wrote:
> Well, I just looked for "ethernet protocol" and read some things about  
> DHCP again.
> 
> What's an ethernet protocol?
> 
> I also read, that "DHCP is built directly on UDP and IP" (RFC 2131).
> 
> It uses Ports (UDP 67/68) and the source address of the DHCP server is  
> an IP address.

Ah, right. I confused it with the way that the ancient RARP protocol did
this before DHCP.

Sorry for the confusion.
 
> Could you answer me more in detail, why I get an IP, but block  
> everything with iptables?

The dhcp client opens a raw packet socket at the ethernet device
(if I'm not mistaken again), because there is no IP address assigned
with the netdev at that time. This allows it to send and receive
ethernet frames, bypassing the TCP/IP stack.

	Arnd <><
