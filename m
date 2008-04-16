Return-Path: <linux-kernel-owner+w=401wt.eu-S933133AbYDPPlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbYDPPlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759385AbYDPPkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:40:52 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2603 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbYDPPkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:40:51 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: Re: TG3 network data corruption regression 2.6.24/2.6.23.4
Date: Wed, 16 Apr 2008 08:40:25 -0700
Message-ID: <1551EAE59135BE47B544934E30FC4FC002AABC73@nt-irva-0751.brcm.ad.broadcom.com>
In-Reply-To: <20080415.203108.55491723.davem@davemloft.net>
Thread-Topic: TG3 network data corruption regression 2.6.24/2.6.23.4
Thread-Index: AcifclI9ra61dZqDSI+8pAMjmsRE3wAZP0rQ
From: "Michael Chan" <mchan@broadcom.com>
To: "David Miller" <davem@davemloft.net>, tonyb@cybernetics.com
cc: "Matthew Carlson" <mcarlson@broadcom.com>, herbert@gondor.apana.org.au,
       netdev@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org
X-WSS-ID: 6418C2663M813353042-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> Matt, skb->mac_header is either a pointer or an integer offset
> depending upon whether we are building 32-bit or 64-bit.
> 
> Testing skb->mac_header is therefore wrong, because it's an
> offset from a pointer in the 64-bit case and therefore it's
> alignment does not indicate correctly the actual final alignment
> of skb->head + skb->max_header.
> 
> Therefore you should test skb_mac_header(skb) and cast it with
> (unsigned long).

Isn't it better to test for skb->data?  That's where we tell
the hardware to start transmitting.

> 
> Please respin this fix with that correction so I can apply it
> and get this bug fixed, thanks!
> 
> 

We think that this problem is unique in Tony's environment because
of the PCIE-to-PCI bridge that he is using.  We therefore want to
test for that bridge and apply the workaround only when it's present.
We've never seen this problem in the last 6 or 7 years during the
lifetime of the 5701.

We'll try to get this done ASAP.

Thanks.

