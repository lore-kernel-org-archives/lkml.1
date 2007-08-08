Return-Path: <linux-kernel-owner+w=401wt.eu-S1765090AbXHHMEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765090AbXHHMEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 08:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbXHHMEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 08:04:46 -0400
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:50668 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756948AbXHHMEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 08:04:45 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=cX/4gD47gMrzSWPZTt7ga6223aBi2BeRZJdPMlwtajT3sWNmN0uEDwR+I6b9LJGV79x/e1n/fu/i0+WEDgJlVOd7IvzMSIs6Oun5ey3mXuLyX2aOs94nIuvPHeBOlOJC;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.19,235,1183327200"; 
   d="scan'208";a="79515793"
Message-ID: <46B9B156.20802@fujitsu-siemens.com>
Date: Wed, 08 Aug 2007 14:04:38 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: "vgoyal@in.ibm.com" <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
References: <46B73955.2080007@fujitsu-siemens.com> <20070807142928.GA18839@in.ibm.com> <46B8AECA.7050908@fujitsu-siemens.com> <m1ir7qg7kd.fsf@ebiederm.dsl.xmission.com> <46B986D5.2010407@fujitsu-siemens.com> <20070808093336.GB13808@in.ibm.com>
In-Reply-To: <20070808093336.GB13808@in.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

>>> How bad is it if you just run with irqpoll in the kdump kernel?
>>> If running with irqpoll is usable that is probably preferable
>>> to putting in a hardware work around we can survive without.
>> Yes, I tried that. No effect.
>>
> 
> Martin, at least irpoll should have worked. I am assuming your timer
> interrupts are coming in second kernel. In that case we are not
> dependent at all on actually receiving device interrupt. Polling should
> take care of it.

You are right. I just tested irqpoll again , and it does works even if the error
(detected by the IRR bit set in the IO-APIC) occurs.

I have no idea what went wrong when I tried "irqpoll" last time. But I was
using a different kernel, controller firmware, driver, and HW configuration,
so it can probably be explained somehow. Unfortunately, the unsuccessful early
attempts caused me to conclude prematurely that "irqpoll" didn't help. I admit
I didn't understand "irqpoll" fully until just now.

> What is that device which is not working? What is the success criterion?

It's a LSI megaraid_sas "zero channel RAID" (ZCR) controller. The system has an
on-board LSI 1068 (mptsas). If you put the ZCR in a certain PCI slot, the
1068 is hidden from the system, which sees the megaraid_sas controller
(1000:0413) instead of the 1068. The ZCR internally uses the 1068 as low-level
controller.

The success criterion was that the disks on the ZCR were successfully detected
and the dump was written.

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
