Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbYFWRFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbYFWRFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYFWREu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:04:50 -0400
Received: from webmail.e-teleport.net ([213.190.83.68]:51934 "EHLO
	mail.imsnet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbYFWREt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:04:49 -0400
Message-ID: <485FD7AD.5080302@e-teleport.net>
Date: Mon, 23 Jun 2008 19:04:45 +0200
From: =?ISO-8859-1?Q?S=E9guier_R=E9gis?= <rseguier@e-teleport.net>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, alan@redhat.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: via-velocity.c fix sleep-with-spinlock bug during
 MTU change
References: <20080604215909.GA17446@electric-eye.fr.zoreil.com> <20080614212341.GA12976@electric-eye.fr.zoreil.com> <4856DA62.7080803@e-teleport.net> <20080617214538.GA6388@electric-eye.fr.zoreil.com> <48584AA4.8040801@e-teleport.net> <48593E35.1010409@e-teleport.net> <20080618201012.GA4019@electric-eye.fr.zoreil.com> <48598784.40306@e-teleport.net> <20080619204312.GA2160@electric-eye.fr.zoreil.com> <485B8542.7060204@e-teleport.net> <20080620103910.GA21227@electric-eye.fr.zoreil.com>
In-Reply-To: <20080620103910.GA21227@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu a écrit :
> Séguier Régis <rseguier@e-teleport.net> :
> [...]
>   
>> But if I generate a paquet with a size more than around 3825, the driver 
>> don't send it and no paquet is send after, work again after an interface 
>> down/up and until no paquet > 3825.
>>     
>
> Does it qualify as a regression ?
>
>   
No,

I test with the version of the driver before patches and I have the same 
error.

I think error is in TX. (TX and RX equipments for the test have the same 
chip, I don't have other kind of chip available at the moment, that why 
I not sure)

If theses informations help :

When I transmit a paquet of ~ 4000 (for a mtu 4500),

When I reboot and PCIE-AER is compiled, I got this message :

Jun 23 18:28:31 apollo kernel: +------ PCI-Express Device Error ------+
Jun 23 18:28:31 apollo kernel: Error Severity^I^I: Uncorrected (Non-Fatal)
Jun 23 18:28:31 apollo kernel: PCIE Bus Error type^I: Transaction Layer
Jun 23 18:28:31 apollo kernel: Unsupported Request   ^I: Multiple
Jun 23 18:28:31 apollo kernel: Requester ID^I^I: 0300
Jun 23 18:28:31 apollo kernel: VendorID=1106h, DeviceID=3119h, Bus=03h, 
Device=00h, Function=00h
Jun 23 18:28:31 apollo kernel: TLB Header:
Jun 23 18:28:31 apollo kernel: 40000001 0018000c febffc7c 0000fdff
Jun 23 18:28:31 apollo kernel: Broadcast error_detected message
Jun 23 18:28:31 apollo kernel: Broadcast mmio_enabled message
Jun 23 18:28:31 apollo kernel: Broadcast resume message

When I reboot and "PCIE-AER and MSI" is compiled, I got this message :

Jun 23 18:35:59 apollo kernel: irq 163, desc: c0495dc8, depth: 1, count: 
0, unhandled: 0
Jun 23 18:35:59 apollo kernel: ->handle_irq():  c012d997, 
handle_bad_irq+0x0/0x199
Jun 23 18:35:59 apollo kernel: ->chip(): c0496b20, 0xc0496b20
Jun 23 18:35:59 apollo kernel: ->action(): 00000000
Jun 23 18:35:59 apollo kernel:   IRQ_DISABLED set
Jun 23 18:35:59 apollo kernel: unexpected IRQ trap at vector a3
-- 
Régis
