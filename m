Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbXKWBNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbXKWBNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 20:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXKWBNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 20:13:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46647
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbXKWBNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 20:13:07 -0500
Date: Thu, 22 Nov 2007 17:13:06 -0800 (PST)
Message-Id: <20071122.171306.166854987.davem@davemloft.net>
To: jeff@garzik.org
Cc: yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [RFC/PATCH] SO_NO_CHECK for IPv6
From: David Miller <davem@davemloft.net>
In-Reply-To: <4744CAA4.50102@garzik.org>
References: <20071121124532.GA17263@havoc.gtf.org>
	<20071121.222051.94402865.yoshfuji@linux-ipv6.org>
	<4744CAA4.50102@garzik.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Wed, 21 Nov 2007 19:17:40 -0500

> YOSHIFUJI Hideaki / 吉藤英明 wrote:
> > In article <20071121124532.GA17263@havoc.gtf.org> (at Wed, 21 Nov 2007 07:45:32 -0500), Jeff Garzik <jeff@garzik.org> says:
> > 
> >> SO_NO_CHECK support for IPv6 appeared to be missing. This is presented,
> >> based on a reading of net/ipv4/udp.c.
> > 
> > Disagree. UDP checksum is mandatory in IPv6.
> 
> Ah, you mean that I need to turn off UDP checksum on receive end as well 
> in IPv6...  true.
> 
> For those interested, I am dealing with a UDP app that already does very 
> strong checksumming and encryption, so additional software checksumming 
> at the lower layers is quite simply a waste of CPU cycles.  Hardware 
> checksumming is fine, as long as its "free."

Regardless of whatever verifications your application is doing
on the data, it is not checksumming the ports and that's what
the pseudo-header is helping with.

You cannot disable checksums in ipv6/UDP, they are not optional and
with %99.9999999 of cards doing the checksum in hardware, and even if
we do have to compute it it's free during the copy during recvmsg().
