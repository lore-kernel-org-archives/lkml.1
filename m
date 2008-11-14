Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYKNECt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYKNECt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 23:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbYKNECj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 23:02:39 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:52607 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYKNECi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 23:02:38 -0500
Message-ID: <491CF82B.7040703@oracle.com>
Date: Thu, 13 Nov 2008 20:01:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] Store the relevant miscdevice in file->private_data in
 misc_open()
References: <b0f1032863818f2834094e2ca9ce4b1c13122748.1226551772.git.michael@ellerman.id.au> <20081113173127.GB30811@kroah.com> <1226620481.8066.18.camel@localhost> <20081114001818.GB20023@kroah.com> <1226631052.8066.25.camel@localhost> <20081114032313.GB15204@kroah.com>
In-Reply-To: <20081114032313.GB15204@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.491CF82F.0092:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Nov 14, 2008 at 01:50:52PM +1100, Michael Ellerman wrote:
>> On Thu, 2008-11-13 at 16:18 -0800, Greg KH wrote:
>>> On Fri, Nov 14, 2008 at 10:54:41AM +1100, Michael Ellerman wrote:
>>>> On Thu, 2008-11-13 at 09:31 -0800, Greg KH wrote: 
>>>>> On Thu, Nov 13, 2008 at 03:49:50PM +1100, Michael Ellerman wrote:
>>>>>> Currently it's not easy to share file_operations between multiple
>>>>>> instances of a miscdevice. In order to do this, the device code needs to
>>>>>> store a list of all it's miscdevice instances, and when fops->open() is
>>>>>> called, search the list and find the right device based on the minor
>>>>>> number.
>>>>>>
>>>>>> However the generic miscdevice code already has a list of miscdevices,
>>>>>> and uses this to find the right device in misc_open(). If misc_open()
>>>>>> would store the miscdevice it found in file->private_data, then the
>>>>>> device code wouldn't need to worry about storing it's own separate list
>>>>>> and searching that as well.
>>>>>>
>>>>>> The rest of the miscdevice code does not use file->private_data, so the
>>>>>> device code is still free to use file->private_data for something else
>>>>>> if it wants to.
>>>>>>
>>>>>> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
>>>>> Do you have a follow-on patch for some misc device using code that would
>>>>> take advantage of this change?
>>>> Ah, good point. I do, but not for upstream :/
>>> Hm, then I have to ask why should we take this change?
>> Because it's seems like a good idea.
> 
> You know we don't make changes to core code for drivers that aren't in
> the main tree, this is not a new thing...
> 
>>> And why would the driver not be availble for upstream to take?
>> Because it's a hacky pile of crud, and it's for unreleased and
>> non-existent hardware.
> 
> That's what the drivers/staging/ tree is for, send it on over to me and
> I'll add it to that location.

for non-existent hardware??  that's not a good plan.


-- 
~Randy
