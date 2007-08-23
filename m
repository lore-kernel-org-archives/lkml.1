Return-Path: <linux-kernel-owner+w=401wt.eu-S1765895AbXHWS7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765895AbXHWS7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 14:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764698AbXHWS7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 14:59:24 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:52411 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764647AbXHWS7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 14:59:23 -0400
Message-ID: <46CDD904.3050607@linux.vnet.ibm.com>
Date: Fri, 24 Aug 2007 00:29:16 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [BUG] 2.6.23-rc3-mm1 - kernel BUG at net/core/skbuff.c:95!
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC33EC.1040803@linux.vnet.ibm.com> <20070822085002.8a116f72.akpm@linux-foundation.org> <1187805493.5303.11.camel@lov.localdomain> <46CC88B3.6080000@linux.vnet.ibm.com> <1187816149.5303.44.camel@lov.localdomain>
In-Reply-To: <1187816149.5303.44.camel@lov.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Thu, 2007-08-23 at 00:34 +0530, Balbir Singh wrote:
>> Kay Sievers wrote:
>>>> gargh, sorry, that's probably due to my screwed up attempt to fix Kay's
>>>> screwed up
>>>> gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch.
>>>>
>>>> Kay sent an update patch but it didn't arrive in time.
>>>>
>>>> Greg, if you haven't yet merged that, please do so asap?
>>>>
>>>> So what _should_ this:
>>>>
>>>> --- a/arch/powerpc/kernel/vio.c~fix-4-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct
>>>> +++ a/arch/powerpc/kernel/vio.c
>>>> @@ -373,7 +373,7 @@ static int vio_hotplug(struct device *de
>>>>  	dn = dev->archdata.of_node;
>>>>  	if (!dn)
>>>>  		return -ENODEV;
>>>> -	cp = of_get_property(dn, "compatible", &length);
>>>> +	cp = of_get_property(dn, "compatible", &env->buflen);
>>>>  	if (!cp)
>>>>  		return -ENODEV;
>>>>  
>>>> _
>>>>
>>>> have done?
>>> Does replacing "&length" with "NULL" work? That's what's in the updated
>>> patch.
> 
>> replacing &length with NULL does not work for me. I get a message saying that
>> init terminated with signal 7.
> 
> Hi Balbir,
> ugh, I can't see what's going wrong here.
> 
> Care to just "return 0" for the whole function, and try again? Just to
> rule out that this is the cause of the problem.
> 

Hi, Kay,

I just confirmed, your NULL fix looks correct. The init got signal 7
problem occurs even if uevent_add_var() is commented out. I suspect that
we are seeing a machine exception, I'll debug that part now.

> Thanks,
> Kay
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
