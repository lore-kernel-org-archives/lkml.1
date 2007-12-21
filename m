Return-Path: <linux-kernel-owner+w=401wt.eu-S1765376AbXLUAoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765376AbXLUAoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbXLUAog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:44:36 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:29652 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbXLUAof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:44:35 -0500
Date: Thu, 20 Dec 2007 18:44:08 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
In-reply-to: <fa.d8kGTkzOZH22bXRIRiakqgOPBM4@ifi.uio.no>
To: tcamuso@redhat.com
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
Message-id: <476B0C58.4030703@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.HvUNJ45qy60H427u0v9fNt3Gc7E@ifi.uio.no>
 <fa.uuzqvr64HFsgxfiWwhEmE16Di6c@ifi.uio.no>
 <fa.zhxdNN/1rfQhfJLVmdGBjvKYrCM@ifi.uio.no>
 <fa.z1qlON6DA9ubBPFdrEcaFTMgYOY@ifi.uio.no>
 <fa.U/SCC1Gvd3nSOpkMu5vcsSPYyPE@ifi.uio.no>
 <fa.d8kGTkzOZH22bXRIRiakqgOPBM4@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Camuso wrote:
> Greg KH wrote:
>>
>> Sure, I realize this, but it solves the problem in one way for broken
>> hardware, such that it at least allows it to work, right?  It also
>> provides a better incentive for the manufacturer to fix their bios,
>> which as you are on-site at HP, it would seem odd that they would just
>> not do that instead of trying to work around this in the kernel...
>>
>> thanks,
>>
>> greg k-h
> 
> I don't think that many OEMs have that much control over the BIOS in
> their "value lines".
> :)
> 
> And the MMCONFIG problem with enterprise systems and workstations, where
> we do control the BIOS (for the most part), is due to known bugs in
> certain versions of certain chipsets, HT1000, AMD8132, among them, not
> the BIOS.
> 
> Anyway, we are devising better ways to deal with these anomalies
> than blacklists and telling customers to use "pci=nommconf"
> 
> And we're bringing them to the community for discussion, improvement,
> and, we hope, acceptance.

First off, I would like to see confirmation from the horses's mouths 
here (namely AMD, ServerWorks/Broadcom, and whoever else) that there is 
no other way to get around this problem than disabling MMCONFIG for 
accesses behind those chips.

The case of the device built into the K8 northbridge that's unreachable 
by MMCONFIG kind of makes sense, since the northbridge is what's 
translating the MMCONFIG memory access into config accesses. It seems 
bizarre to me that a bridge chip could possibly have such a problem. The 
MMCONFIG access should get translated into a configuration space access 
in the northbridge and from that point on there's no difference between 
an MMCONFIG and type1 access.

Look at MSI for another example, we recently had a patch from NVIDIA 
posted to enable Hypertransport MSI mapping bits on some chipsets so 
that MSI would function, because the BIOS failed to set them up 
properly. Are we sure there's not a similar BIOS configuration issue 
that could ideally be fixed in the BIOS, or else fixed up in the kernel?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

