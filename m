Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbZDWVip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbZDWVip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbZDWVif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:38:35 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45835 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbZDWVid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:38:33 -0400
Message-ID: <49F0DFD7.5040107@linux.vnet.ibm.com>
Date: Thu, 23 Apr 2009 14:38:31 -0700
From: jvrao <jvrao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Mike Anderson <andmike@linux.vnet.ibm.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Linux Driver <Linux-Driver@qlogic.com>
Subject: Re: Interrupts are being dropped under heavy IO on -rt .
References: <49DF71CF.7070509@linux.vnet.ibm.com> <20090415194802.GD1382@plap4-2.local>
In-Reply-To: <20090415194802.GD1382@plap4-2.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Vasquez wrote:
> On Fri, 10 Apr 2009, jvrao wrote:
> 
>> Qlogic driver uses MSI-EDGE interrupts by default.
>>  
>> On -rt kernel under heavy IO load we observed that the driver missed 
>> interrupts occasionally.
>>
>> Missing interrupts caused spurious mailbox timeouts and path failovers.
>>
>> Suspecting MSI interrupts, we disabled MSI and forcing the driver to use 
>> APIC interrupts (Patch attached).
>>
>> With this change, our IO tests ran for extended period of time without 
>> any issues.
>>
>> It would be interesting to see if the MSI infrastructure itself has 
>> issues on realtime, or it is the combination of qla2xxx/MSI.
>>
>> Right now we don't have any setup to test out MSI with other adapters. 
>> Hence, wondering if anyone faced similar issues.
> 
> Could you perhaps provide some details on hardware used within your
> testing -- HBA type, storage, etc?  Also, can you share any logs of
> the failures with extended-error-logging enabled
> (ql2xextended_error_logging)?

Hi, the following link provides more information on the logs and our analysis.

https://bugzilla.redhat.com/show_bug.cgi?id=466903

[root@elm3c29 R2-SR1]# lspci | grep -i qlogic
03:05.0 Fibre Channel: QLogic Corp. ISP2422-based 4Gb Fibre Channel to PCI-X HBA (rev 02)
03:05.1 Fibre Channel: QLogic Corp. ISP2422-based 4Gb Fibre Channel to PCI-X HBA (rev 02)


Storage is DS4700 (Product ID: 1814)

If you need more information, please let me know, I can generate more information/logs.
I will also find time to reproduce this with ql2xextended_error_logging enabled.

Thanks,
JV

> 
> Regards,
> Andrew Vasquez
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


