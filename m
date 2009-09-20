Return-Path: <linux-kernel-owner+w=401wt.eu-S1751463AbZITEqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbZITEqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 00:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZITEqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 00:46:14 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:37772 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZITEqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 00:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iximlim8LswlpeVrhIofcqmG+505wuHoHRMG0vbZ3b3/h0EjoK3Xs84ugAb5252oJ0
         4kEGePsgz3i9VS1XqdRbaqwSgW6xf71+3XRz9mL9Md5c1YmOhTCm/vohYT9GEYcPZop8
         8lRTv6iirZbSqpz0DXk2Nne1+4ITu3+qB8FOY=
Message-ID: <4AB5B395.80400@gmail.com>
Date: Sat, 19 Sep 2009 22:46:13 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Current git fails to boot with VT-D enabled due to flood of 
  DMAR errors
References: <4AB5B07B.5090506@gmail.com> <1253421668.6317.83.camel@macbook.infradead.org>
In-Reply-To: <1253421668.6317.83.camel@macbook.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2009 10:41 PM, David Woodhouse wrote:
> On Sat, 2009-09-19 at 22:32 -0600, Robert Hancock wrote:
>> On an Asus P7P55D Pro-based system (Lynnfield CPU), with Intel VT-d
>> enabled in the BIOS, on 2.6.30.5 (the previous version I tested) I get
>> these lines in dmesg:
>>
>> DMAR:Host address width 36
>> DMAR:DRHD (flags: 0x00000001)base: 0x00000000fed90000
>> DMAR:RMRR base: 0x00000000000e4000 end: 0x00000000000e7fff
>> DMAR:RMRR base: 0x00000000bf7ec000 end: 0x00000000bf7fffff
>> Not all IO-APIC's listed under remapping hardware
>>
>> In current -git, I get these lines as well, but then I get this:
>>
>> DRHD: handling fault status reg ffffffff
>> DMAR:[DMA Read] Request device [ff:1f.7] fault addr fffffffffffff000
>> DMAR:[fault reason 255] Unknown
>>
>> The last two lines repeat in a continuous flood and the system doesn't
>> boot. This happens even if I pass "intel_iommu=off" (which seems like
>> it's already the default).
>>
>> Could be a kernel bug or a BIOS bug, but in the latter case we should
>> probably deal with it better. The registers all reading FF seems like
>> maybe the registers are disabled or something..
>
> This ought to be 'fixed' in linux-next by this commit:
> http://git.infradead.org/iommu-2.6.git/commitdiff/0815565ad
>
> Please try linux-next or the iommu tree from
> git://git.infradead.org/iommu-2.6.git

Yeah, I just came across that patch. Is that going to get pushed for 
2.6.32? It seems like something caused us to start tripping over this by 
default when we didn't before. (Passing intel_iommu=on with 2.6.30.5 
does cause the same problem.)

I'll try and report the problem to Asus, obviously something's borked 
with VT-d in their BIOS currently..
