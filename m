Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYGVIpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYGVIpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbYGVIph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:45:37 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:32454 "EHLO
	pd2mo1so-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753968AbYGVIpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:45:35 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=r49yaCuOCbK1QH-TmvkA:9 a=mSmMP3ZelyA6qCpuhhYA:7 a=zCD_YcvDlDA5YMC7B1vEluNXwmUA:4 a=759cccFogNYA:10 a=tNCvaO9EbNoA:10 a=CDgK0yFw8z8A:10
Message-ID: <48859E2C.4070805@shaw.ca>
Date: Tue, 22 Jul 2008 02:45:32 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Tomas Styblo <tripie@cpan.org>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix -	device
 152d:2338
References: <fa.eWQqoO1e4Mdhu8SK5jzMFAI/3NU@ifi.uio.no> <4884E585.2050104@shaw.ca> <20080722051110.GA8303@notebook.homenet.local> <488570A5.8000602@shaw.ca> <20080722061147.GB8303@notebook.homenet.local>
In-Reply-To: <20080722061147.GB8303@notebook.homenet.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Styblo wrote:
> * Robert Hancock <hancockr@shaw.ca> [Tue, 22 Jul 2008]:
>> In any case, given that your code apparently fixes the corruption it seems 
>> that srb->result is being set to SAM_STAT_CHECK_CONDITION, but the 
>> DID_ERROR and SUGGEST_RETRY flags are not being set. Presumably then the  
>> SCSI layer looks at the sense data and says "hmm, nothing to worry about 
>> here" and carries on.
> 
> That's exactly what I thought was happening, after a cursory 
> look at the SCSI code.
> 
>> I think we do need something like your patch, though it should likely be 
>> moved inside the if (need_auto_sense) check, and I don't see a reason to 
>> limit to this device ID only.
> 
> Thank you. This is a very insidious bug as it doesn't manifest
> itself very often, months of data corruption may pass before you
> notice it.
> 
> So is there a bug in the chipset, or does the error handling code 
> not follow specifications?

It looks clear to me that it's a bug in the chipset. It's supposed to 
set some valid sense data if an error occurs, not just set the "failed" 
flag in the USB storage status word. (Presumably the fact that these 
errors are occurring in the first place is a bug in itself.. though that 
could be a problem with the enclosure or drive as well.)

However the kernel should be more robust and not ignore the error 
indication that it is giving.

> I wonder if the company that makes the chipset should be notified
> about this problem?

I suppose it wouldn't hurt to let JMicron know about this. I doubt they 
could do anything for existing chipsets, but it might help them avoid 
this bug in future designs.
