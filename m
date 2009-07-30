Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbZG3V6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbZG3V6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZG3V6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:58:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42353 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbZG3V6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:58:05 -0400
Message-ID: <4A721768.2060102@garzik.org>
Date: Thu, 30 Jul 2009 17:58:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Don Fry <pcnet32@verizon.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
       corbet@lwn.net, eteo@redhat.com, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH] pcnet32: VLB support fixes
References: <200907302317.52648.bzolnier@gmail.com> <4A721163.7030700@garzik.org> <200907302346.26017.bzolnier@gmail.com>
In-Reply-To: <200907302346.26017.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Thursday 30 July 2009 23:32:19 Jeff Garzik wrote:
>> Bartlomiej Zolnierkiewicz wrote:
>>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> Subject: [PATCH] pcnet32: VLB support fixes
>>>
>>> VLB support has been broken since at least 2004-2005 period as some
>>> changes introduced back then assumed that ->pci_dev is always valid,
>>> lets try to fix it:
>>>
>>> - remove duplicated SET_NETDEV_DEV() call
>>>
>>> - call SET_NETDEV_DEV() only for PCI devices
>>>
>>> - check for ->pci_dev validity in pcnet32_open()
>>>
>>> [ Alternatively we may consider removing VLB support but there would not
>>>   be much gain in it since an extra driver code needed for VLB support is
>>>   minimal and quite simple. ]
>>>
>>> This takes care of the following entry from Dan's list:
>>>
>>> drivers/net/pcnet32.c +1889 pcnet32_probe1(298) warning: variable derefenced before check 'pdev'
>>>
>>> Reported-by: Dan Carpenter <error27@gmail.com>
>>> Cc: corbet@lwn.net
>>> Cc: eteo@redhat.com
>>> Cc: Julia Lawall <julia@diku.dk>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> ---
>>> PS I still keep the original cc: list from the smatch thread -- please let
>>> me know if you don't want to be spammed.. ;-)
>>>
>>>  drivers/net/pcnet32.c |   12 +++++++-----
>>>  1 file changed, 7 insertions(+), 5 deletions(-)
>> ACK -- the patch is correct AFAICS -- but would it not be better to have 
>> a struct device for the VLB device?
> 
> Sure, such addition would be needed for sysfs support on VLB devices..


>> We have capability to create struct device for isa and eisa, so VLB is 
>> quite doable.
>>
>> 	Jeff, who converted old-ISDN ISA+EISA+PCI drivers to
>> 	      hotplug model, once upon a time
> 
> ..and it seems that you've the needed experience! :)

<grin>  In my esteemed experience, I point you to the 39-line 
include/linux/isa.h as a starting point for grep...  :)

	Jeff




