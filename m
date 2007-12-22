Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbXLVQmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbXLVQmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 11:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXLVQmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 11:42:33 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:56111 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbXLVQmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 11:42:33 -0500
Date: Sat, 22 Dec 2007 10:41:33 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
In-reply-to: <fa.pdOcVPk2gFn5iK76ExRH6Ow+NPw@ifi.uio.no>
To: Loic Prylli <loic@myri.com>
Cc: tcamuso@redhat.com, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
Message-id: <476D3E3D.80005@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.HvUNJ45qy60H427u0v9fNt3Gc7E@ifi.uio.no>
 <fa.zhxdNN/1rfQhfJLVmdGBjvKYrCM@ifi.uio.no>
 <fa.z1qlON6DA9ubBPFdrEcaFTMgYOY@ifi.uio.no>
 <fa.U/SCC1Gvd3nSOpkMu5vcsSPYyPE@ifi.uio.no>
 <fa.d8kGTkzOZH22bXRIRiakqgOPBM4@ifi.uio.no>
 <fa.pdOcVPk2gFn5iK76ExRH6Ow+NPw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loic Prylli wrote:
> On 12/20/2007 6:21 PM, Tony Camuso wrote:
>> And the MMCONFIG problem with enterprise systems and workstations, where
>> we do control the BIOS (for the most part), is due to known bugs in
>> certain versions of certain chipsets, HT1000, AMD8132, among them, not
>> the BIOS.
> 
> 
> 
> The lack of MMCONFIG support is indeed because some hypertransport
> chipsets lack that support. But there are some BIOSes out there that are
> advertising support for all busses in their MCFG acpi attribute (even
> the busses managed by some amd8131 in a mixed nvidia-ck804/amd8131
> motherboard), and the BIOS seems at least faulty for advertising a
> capability that does not exist.

This didn't really occur to me before for some reason. But yes, the MCFG 
table lists the buses to which each MMCONFIG region is applicable. If 
there are entire buses which MMCONFIG cannot access, it should not be 
indicating they are accessible via MMCONFIG in the ACPI MCFG table. If 
it is, then it's truly a BIOS bug.

Unless of course Linux isn't handling what the MCFG table is indicating 
properly. Then it's our bug. It would be good to verify this on one of 
the systems involved..

One of the things this patch (currently in -mm) does is dump out the 
segment and starting/ending buses for each MCFG configuration listed. 
The dmesg from this patch applied on such a system would tell you which 
is the case:

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commit;h=e18c985289ee356f06dbc953281a3c140a02fbb3

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

