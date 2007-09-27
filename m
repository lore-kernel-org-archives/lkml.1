Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbXI0UwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbXI0UwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 16:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXI0UwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 16:52:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:54529 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbXI0Uv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 16:51:59 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] Add iSCSI iBFT support.
Date: Thu, 27 Sep 2007 16:50:42 -0400
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>, Konrad Rzeszutek <konrad@darnok.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Konrad Rzeszutek <konradr@redhat.com>, konradr@linux.vnet.ibm.com
References: <20070926184652.GA16369@andromeda.dapyr.net> <46FBE5D2.6090306@zytor.com> <46FBED88.8060200@redhat.com>
In-Reply-To: <46FBED88.8060200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271650.43087.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 September 2007 13:51, Peter Jones wrote:
> H. Peter Anvin wrote:
> > Peter Jones wrote:
> >>> It should, presumably, depend on ACPI, rather than on X86...?
> >> Actually no.  That /should/ be the correct answer, but none of the
> >> hardware vendors actually provide the table via ACPI yet.  Also, if they
> >> did, the support for /sys/firmware/acpi/tables/* would be sufficient
> >> instead of having this code *at all*.
> >>
> > 
> > Is there anything other than the discovery which is braindead about
> > iBFT?  If so, can the tables code be taught to look for this additional
> > table instead of having all its own mechanism?
> 
> Well, the code for the the generic ACPI table sysfs functionality is 
> expecting to find the tables indexed in the RSDT.  This is essentially 
> what the iBFT spec's authors seem to have planned, but it's simply never 
> been implemented in the firmware.
> 
> AFAICS, it's technically feasible to remove the sysfs parts of this code 
> entirely, make the probe code build a fake ACPI table header, and then 
> add it explicitly if present at the end of acpi_system_sysfs_init() .
> 
> I don't know how the ACPI guys would feel about that.  Len, thoughts?

Technically, ACPI knows only about devices that are soldered onto
the motherboard when the BIOS is flashed.
So ACPI wouldn't be able to help you find this table
when you put in an iSCSI card -- unless there were some arrangement
between the motherboard BIOS and the add-in card BIOS extension,
say, to have a dummy table that gets filled in or something.

Yes, OpenFirmware is extensible via add-in cards -- assuming
they support OpenFirmware -- so in theory they could do this right
even in the add-in case.

I wouldn't object to a platform hook to make the IBFT appear as just another
ACPI table available in /sys/firmware/acpi.  But that woudln't help
a system that has IBFT but doesn't have ACPI, so it doesn't
really solve the general problem.

For tables such as this,
ACPI is just the messenger anyway, we don't know anything about
the content of the table, just about the envelope around it
and how to find the envelope.  In this case, we don't even
know how to find the envelope, so ACPI doesn't add much
value to the IBFT.

In summary, I think IBFT should depend on iSCSI alone,
and not involve ACPI at all.
 
-Len

