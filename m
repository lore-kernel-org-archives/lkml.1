Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbZJMRcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbZJMRcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 13:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760764AbZJMRcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 13:32:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:33645 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760762AbZJMRcG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:32:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,551,1249282800"; 
   d="scan'208";a="198462802"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Justin Piszcz <jpiszcz@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-net@vger.kernel.org" <linux-net@vger.kernel.org>
Date: Tue, 13 Oct 2009 10:31:26 -0700
Subject: RE: Intel on-board NIC negotiates at 10mbps instead of 1gbps (new
 	Intel P55KG motherboard), driver bug?
Thread-Topic: Intel on-board NIC negotiates at 10mbps instead of 1gbps (new
 	Intel P55KG motherboard), driver bug?
Thread-Index: AcpMHXjWjE8PieOxQsW3jzD62Wlv+QADEtag
Message-ID: <8DD2590731AB5D4C9DBF71A877482A903AF0CBF5@orsmsx509.amr.corp.intel.com>
References: <ba1f10320910130446g33264abfy845e28856e2e6f69@mail.gmail.com>
 <ba1f10320910130807r3f8ed8a5h543c14259d1bd1b@mail.gmail.com>
In-Reply-To: <ba1f10320910130807r3f8ed8a5h543c14259d1bd1b@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whom did you speak with at Intel?  They were obviously mistaken when they said both Linux has not been tested on the board as well as not providing drivers for it.  I'd like to correct that on our end if I can.

Initial support for this device was pushed upstream a while ago.  Your exact issue however is a known one with newer GbE EEPROMs provided with the latest hardware.  The fix is in the queue to be pushed upstream, but in the meantime you can run the latest e1000e driver (version 1.0.15) found on e1000.sourceforge.net which already has the fix.

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>owner@vger.kernel.org] On Behalf Of Justin Piszcz
>Sent: Tuesday, October 13, 2009 8:07 AM
>To: linux-kernel@vger.kernel.org
>Cc: linux-net@vger.kernel.org
>Subject: Re: Intel on-board NIC negotiates at 10mbps instead of 1gbps (new
>Intel P55KG motherboard), driver bug?
>
>On Tue, Oct 13, 2009 at 7:46 AM, Justin Piszcz <jpiszcz@gmail.com> wrote:
>> Hello,
>>
>> I recently purchased/installed an Intel DP55KG motherboard and when I
>> boot from the System Rescue CD (1.3.0) the on-board NIC only
>> negotiates at 10mbps, when I plug the same cable into two other Intel
>> x1 PCI-e nics, they negotiate at 1gbps without any issue.  My old
>> system also negotiated at 1gbps (a DG965WH) board.
>>
>> I understand support for chip has recently been added to the e1000e
>> driver, has this been resolved in newer kernels?
>>
>> I am asking as I am still running memtest etc before putting the box
>> in production, thanks.
>>
>> From the logs:
>>
>> e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
>> e1000e: Copyright (c) 1999-2008 Intel Corporation.
>> e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
>> e1000e 0000:00:19.0: pci_enable_pcie_error_
>> reporting failed 0xfffffffb
>> e1000e 0000:00:19.0: setting latency timer to 64
>> e1000e 0000:00:19.0: irq 36 for MSI/MSI-X
>> 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) (mac address)
>> 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
>> 0000:00:19.0: eth0: MAC: 9, PHY: 9, PBA No: ffffff-0ff
>>
>> e1000e 0000:00:19.0: irq 36 for MSI/MSI-X
>> e1000e 0000:00:19.0: irq 36 for MSI/MSI-X
>> ADDRCONF(NETDEV_UP): eth0: link is not ready
>> e1000e: eth0 NIC Link is Up 10 Mbps Full Duplex, Flow Control: RX
>> 0000:00:19.0: eth0: 10/100 speed: disabling TSO
>> ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>> eth0: no IPv6 routers present
>>
>> Please cc as I am not on the lists, thanks.
>>
>> (resent as plain-text)
>>
>> Justin.
>>
>
>
>I spoke with Intel, they said they do not support Linux :-P
>
>"However, Linux* has not been tested on this desktop board and we do
>not offer any drivers for that operating system."
>
>-- Can someone from Intel on the list (or linux-net) comment on this?
>If the problem still occurs with the latest 2.6.31-rcX, I should try
>and/or use the latest e1000e driver from here:
>http://sourceforge.net/projects/e1000/ -- aside from that, are there
>any other workarounds (if the problem persists)?
>
>I have used the same cable with 3 different NICs (two x1 PCI-e) and
>the last system I had was PCI-e (on-board) all negotiated 1gbps, this
>one though only negotiates at 10mbps duplex.
>
>Is this a known bug?
>
>Justin.
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
