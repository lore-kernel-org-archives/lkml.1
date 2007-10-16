Return-Path: <linux-kernel-owner+w=401wt.eu-S933716AbXJPOjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716AbXJPOjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932967AbXJPOjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:39:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41978 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932764AbXJPOjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:39:24 -0400
Date: Tue, 16 Oct 2007 15:43:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Konstantin Kalin <konstantin.kalin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NVIDIA Ethernet & invalid MAC
Message-ID: <20071016154313.53d19c43@the-village.bc.nu>
In-Reply-To: <4714C66D.4010607@gmail.com>
References: <4714C66D.4010607@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 18:10:53 +0400
Konstantin Kalin <konstantin.kalin@gmail.com> wrote:

> Hello,
> 
> Recently we've got some computers with new motherboard having NVidia 
> chipset. The motherboard has nforce12 & nforce13 Ethernet cards. I've 
> noticed that MAC address is setup random each boot. I debugged the 
> driver and found that these cards have right-byte order of MAC address 
> but the driver is expecting incorrect byte-order for these models.

The only obvious thing I can think of to try would be to read the MAC
address both ways around.

The first 3 bytes of the resulting MAC should always be the Nvidia
allocation as I understand it and if so you can then decide which way
around is correct. 

ie if it starts 00:04:0B then you know which way around it goes. (there
is one address that is the same either way around but clearly that one
doesn't matter).

So perhaps do that and for the afflicted parts add an EITHER_WAY_AROUND
flag ?

Alan
