Return-Path: <linux-kernel-owner+w=401wt.eu-S936963AbXHHSH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936963AbXHHSH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761235AbXHHSHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:07:19 -0400
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:44559 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759320AbXHHSHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:07:17 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=NL/sSNRdLX8hnkyfKbNSwKBtQIcft7dP8GT02WDUgyOuOtuOxBRbGT+L3kV3vkl4ITy5HiSFIV3LPCeHJnpw1VG0UeuEIIh0ny20EyOgXX0tEPZ45EJbgsUZVc5h+5XA;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.19,236,1183327200"; 
   d="scan'208";a="79567603"
Message-ID: <46BA0651.5010708@fujitsu-siemens.com>
Date: Wed, 08 Aug 2007 20:07:13 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: "vgoyal@in.ibm.com" <vgoyal@in.ibm.com>
Cc: Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
References: <46B73955.2080007@fujitsu-siemens.com> <20070808113834.GA26145@in.ibm.com>
In-Reply-To: <20070808113834.GA26145@in.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:

> Got this oops while testing your patch when I did
> "echo c > /proc/sysrq-trigger"

That's bad :-(

...
> Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
 [<0000000000000000>]
>  <IRQ>  [<ffffffff8025afd0>] handle_edge_irq+0x5c/0x127
>  [<ffffffff8020e1ae>] do_IRQ+0xf1/0x15f
>  [<ffffffff8020c191>] ret_from_intr+0x0/0xa
>  <EOI>  <NMI>  [<ffffffff80351ae3>] __delay+0x6/0x10
>  [<ffffffff8021e328>] crash_nmi_callback+0x4b/0x77

Obviously, it the oops occurs after the IRQs are re-enabled in crash_nmi_callback().
It appears that desc->chip->mask (in mask_ack_irq(), kernel/irq/chip.c:462) was NULL.
I have no idea how my patch could cause that.

This proves that re-enabling IRQs in this situation is too dangerous :-(.
I really did hundreds of dumps in different ways (echo c>/proc/sysrq-trigger,
forcing Oops and panic(), actually hititng Alt-Sysrq) and this never happened to
me.

Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DE6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 8 15113
Fax:			++49 5251 8 20409
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
