Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbXI0R5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbXI0R5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 13:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbXI0R5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 13:57:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbXI0R5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 13:57:43 -0400
Message-ID: <46FBED88.8060200@redhat.com>
Date: Thu, 27 Sep 2007 13:51:04 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>
CC: Konrad Rzeszutek <konrad@darnok.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Konrad Rzeszutek <konradr@redhat.com>, konradr@linux.vnet.ibm.com
Subject: Re: [PATCH] Add iSCSI iBFT support.
References: <20070926184652.GA16369@andromeda.dapyr.net> <20070926142950.46bbfcd2.randy.dunlap@oracle.com> <200709262052.44845.konrad@darnok.org> <46FBE30D.7010108@zytor.com> <46FBE478.6040602@redhat.com> <46FBE5D2.6090306@zytor.com>
In-Reply-To: <46FBE5D2.6090306@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Peter Jones wrote:
>>> It should, presumably, depend on ACPI, rather than on X86...?
>> Actually no.  That /should/ be the correct answer, but none of the
>> hardware vendors actually provide the table via ACPI yet.  Also, if they
>> did, the support for /sys/firmware/acpi/tables/* would be sufficient
>> instead of having this code *at all*.
>>
> 
> Is there anything other than the discovery which is braindead about
> iBFT?  If so, can the tables code be taught to look for this additional
> table instead of having all its own mechanism?

Well, the code for the the generic ACPI table sysfs functionality is 
expecting to find the tables indexed in the RSDT.  This is essentially 
what the iBFT spec's authors seem to have planned, but it's simply never 
been implemented in the firmware.

AFAICS, it's technically feasible to remove the sysfs parts of this code 
entirely, make the probe code build a fake ACPI table header, and then 
add it explicitly if present at the end of acpi_system_sysfs_init() .

I don't know how the ACPI guys would feel about that.  Len, thoughts?

-- 
   Peter
