Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYG3Tzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYG3Tzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYG3Tzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:55:38 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:3217 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755575AbYG3Tzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:55:37 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=VwQbUJbxAAAA:8 a=4SEYrVf_bg6V_80FIRsA:9 a=ltV_l5kj8GDCY0jjnNEbiQ6BVf0A:4 a=Gr1l-fY1kBQA:10 a=CDgK0yFw8z8A:10
Message-ID: <4890C72D.7040604@shaw.ca>
Date: Wed, 30 Jul 2008 13:55:25 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Tomas Styblo <tripie@cpan.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
References: <Pine.LNX.4.44L0.0807232337110.25883-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807232337110.25883-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Wed, 23 Jul 2008, Robert Hancock wrote:
> 
>> It remains an issue, though, that if there's no underflow, if the device 
>> reports an error in the CSW but doesn't provide sense data, we assume 
>> nothing bad happened and don't retry. That definitely does not seem 
>> correct. The device is not supposed to do this, but with how crappily 
>> some of these devices are designed we should be more defensive.
> 
> The problem is, what can you do?  The device has said that something 
> was wrong, but it hasn't told you what.  Without knowing what went 
> wrong, you can't know how to recover.
> 
> I suppose in such cases we could simply report that the command failed
> completely.

I think that is what we need to do. The SCSI/block layers should retry 
the command or report a failure to userspace. Above all else we can't 
just continue on our merry way and assume success, otherwise data will 
get silently corrupted.

It could be that's what Windows is doing, and it's just silently 
retrying commands. Though, some people have reported corruption on these 
chipsets on Windows too, so maybe it has the same issue.

Is that SCSI/USB underflow fix from 
http://bugzilla.kernel.org/show_bug.cgi?id=9638 being pushed forward by 
anybody? If not, I can try and cook up a patch to take care of that as 
well as the non-underflow failed CSW/no sense data issue.
