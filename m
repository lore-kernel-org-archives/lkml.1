Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbZFIL1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbZFIL1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbZFIL1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:27:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:42832 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbZFIL1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:27:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ooWDIM4DAkQ68NPTd5qYbPImWMl9D3H784TYUbNQElTsxDNsBU+zpmJ5Cqim23KqKw
         N8fWvAPPcyU6rlgjE8aIObSsAeSFiX3xErFQBhNTqSoelARzVnALVMQbhCB0H6Q2Nbxn
         pDo4u1RwfmeJFvbPJOMHHYJqcBvS3YMlH7lW0=
MIME-Version: 1.0
In-Reply-To: <4A2E4077.8080407@trash.net>
References: <91ac27070906081105x30171bedra10d244d382a6934@mail.gmail.com>
	 <20090608.143454.161329513.davem@davemloft.net>
	 <4A2E4077.8080407@trash.net>
Date: Tue, 9 Jun 2009 14:27:00 +0300
Message-ID: <91ac27070906090427k6f57745xc72f9fcb6801957a@mail.gmail.com>
Subject: Re: SOCK_RAW does not receive broadcast (with VLAN unless PROMISC)
From: Gil Beniamini <gil.beniamini@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

9Jun09, The problem was seen with eth1 using driver e1000e, but also
was reproduced on 3c59x, to me it seems that the problem is not
related to a specific nic driver.
VLAN is running for other NICs, but on the application specific nic
(eth1) I use PF_PACKET (SOCK_RAW) , in order to get  the raw-packet
from the underlying device, and this start working again (like in
older kernel) as soon as the application set the socket to PROMISC
mode.
Thanks Gil

On Tue, Jun 9, 2009 at 1:59 PM, Patrick McHardy<kaber@trash.net> wrote:
> David Miller wrote:
>>
>> From: Gil Beniamini <gil.beniamini@gmail.com>
>> Date: Mon, 8 Jun 2009 21:05:25 +0300
>>
>>> My application is using PF_PACKET and SOCK_RAW in order to receive all
>>> Ethernet packets for the machine-unicast MAC plus all broadcast
>>> packets (like ARP broadcast).
>>
>>> That worked OK with kernel 2.6.20 (Ubuntu 7.04 with or without VLAN).
>>>
>>> Now with kernel 2.6.28 (Ubuntu 9.04) it works OK only without-VLAN,
>>> but with VLAN the application receive only packets for the
>>> machine-unicast MAC, but no broadcast (like ARP broadcast) packets,
>>> only if I set the socket to PROMISC mode, I start receive also
>>> broadcast packets.
>
> Which driver are you using? Are you sniffing on the VLAN device
> or on the underlying device?
>
>
