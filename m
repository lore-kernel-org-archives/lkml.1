Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbZJIVmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbZJIVmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761503AbZJIVmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:42:20 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:33959 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZJIVmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:42:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=FJ5erImGox+rhfdg7BTP6C23WQyHbdOW2TMqH9yRU9fTQCdrW3PbVqrzULRh9/f5BL
         nF6myZUnbpnzH0raMxF89u8VDSpMiMcVOUOXi5JTXGzj94cpQvR9TOMYI1lghKwtM1wF
         dabi4hfb1PM19nJSB8yr3lezM5aiHbEZtz+o4=
Subject: Re: [PATCH] Cleanups for: line length, printk KERN_ argument, stack frame size > 2048 (added a kmalloc/kfree), style/formatting errors, incorrect include files
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Bruce B <bbeare1@gmail.com>
In-Reply-To: <20091009212947.GA10187@suse.de>
Date: Fri, 9 Oct 2009 14:41:41 -0700
Cc: Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <7186A162-7CF4-4FE1-B0C8-9D296DF20572@gmail.com>
References: <1255122698-12390-1-git-send-email-bbeare1@gmail.com> <20091009211610.GA5005@suse.de> <20091009142742.b12b80b1.randy.dunlap@oracle.com> <20091009212947.GA10187@suse.de>
To: Greg KH <gregkh@suse.de>
X-Mailer: Apple Mail (2.1076)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 9, 2009, at 2:29 PM, Greg KH wrote:

> On Fri, Oct 09, 2009 at 02:27:42PM -0700, Randy Dunlap wrote:
>> On Fri, 9 Oct 2009 14:16:10 -0700 Greg KH wrote:
>>
>>>
>>> Try changing one thing at a time per patch please.
>>>
>>> There's some bugs in here:
>>>
>>>> -		struct config_t dig_in_config[32];
>>>> -		struct config_t dig_out_config[32];
>>>> -		struct config_t chan_in_config[32];
>>>> -		struct config_t chan_out_config[32];
>>>> 		int i;
>>>> +		config_data = kmalloc(sizeof(struct config_data_t), GFP_KERNEL);
>>>
>>> Shouldn't that be:
>>> 		config_data = kmalloc(sizeof(struct config_data_t)*32,  
>>> GFP_KERNEL);
>>
>> The new struct already includes the [32]s.
>
> Ah, missed that.
>
> But your other comment about checking the kmalloc is valid.  We should
> not add new calls to kmalloc that doesn't check, let's not _add_ new
> errors to the code :)
>
> Bruce, care to split this up into individual patches, each doing only
> one thing, and check for the return value of this call?
>
> thanks,
>
> greg k-h

Sure. Glad to.  A little head scratching will be required for the  
general cleanups in the .open routing for the kmalloc calls.
There are several different types of formatting errors that I have  
addressed. Those can be bundled as one patch?

