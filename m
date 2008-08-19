Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbYHSSBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbYHSSBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYHSSBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:01:14 -0400
Received: from mercury.realtime.net ([205.238.132.86]:40341 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753042AbYHSSBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:01:13 -0400
In-Reply-To: <20080817210659.06601a3b@hyperion.delvare>
References: <for-27-patch1-0@bga.com> <200808151046.59590.jbarnes@virtuousgeek.org> <20080815205500.1945916f@hyperion.delvare> <200808151215.02499.jbarnes@virtuousgeek.org> <20080816062259.GB20541@kroah.com> <20080817210659.06601a3b@hyperion.delvare>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <98dd991a397dfe6393cec9f89eae0ba3@bga.com>
Content-Transfer-Encoding: 7bit
Cc: Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       Greg KH <greg@kroah.com>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Date: Tue, 19 Aug 2008 13:01:47 -0500
To: Jean Delvare <khali@linux-fr.org>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 216.126.174.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 17, 2008, at 2:06 PM, Jean Delvare wrote:
> On Fri, 15 Aug 2008 23:22:59 -0700, Greg KH wrote:
>> On Fri, Aug 15, 2008 at 12:15:01PM -0700, Jesse Barnes wrote:
>>> On Friday, August 15, 2008 11:55 am Jean Delvare wrote:
>>>> In fact we can do even better than that. We could accept from
>>>> user-space only driver_data values which at least one device ID 
>>>> entry in
>>>> the driver already uses. That should be fairly easy to implement, 
>>>> and
>>>> would offer a level of safety an order of magnitude above what we 
>>>> have
>>>> at the moment... And it works both ways: if 0 is not a valid data 
>>>> for
>>>> some driver, that would force the user to provide a non-zero (and
>>>> valid) data value. And it guarantees that the user can't ask for
>>>> something the driver doesn't expect, so drivers don't even need 
>>>> extra
>>>> checks. And no need for a use_driver_data flag either.
>>>
>>> Meaning a driver audit of the usage?  Yeah that would be great.

Thanks Jean for doing this.  Sometimes things move quickly after a long 
stall.  I thought about proposing a similar patch and therefore have to 
say Ack.

>>>> The only drawback is that it prevents the user from passing a "new"
>>>> data value even if it would be valid. But honestly, I don't expect 
>>>> that
>>>> case to happen frequently... if ever at all. So I'd say the benefits
>>>> totally outweight the drawback.

There are a few drivers that could benefit, mainly ones that I 
identified as using flags.  For example, the radeon driver uses 
different fields of the data to specify crt controller, video output 
device, etc.   I'm fine with deferring a flag for such drivers until 
someone audits a driver and wants the support.

>>>>
>>>> If the interested people agree with the idea, I'll look into
>>>> implementing it.
>>>
>>> Well the audit would show if user supplied "new" values are needed; 
>>> otherwise
>>> the approach sounds good to me.
>>
>> That sounds reasonable, and should work properly.
>>
>> No objection from me.

so, if anyone asks,

Concept-Acked-By: Milton Miller <miltonm@bga.com>

milton

