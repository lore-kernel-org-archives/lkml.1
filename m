Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbZECUuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbZECUuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 16:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZECUu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 16:50:28 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:33310 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbZECUu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 16:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Bkp/wBpm6jYYjhmgA355TDILpVzxLqB+gRHCVoe/4v0LoJWliDM3d6/OT88/NGTDjJ
         JbgKbvdcvE7uOqndID3uR0G2LnO3seHK03MRHA1+NqNLPZ8GjNz828tKpshxKObWnAPG
         euPSrmd1dAuV1F2b7zbrwTUQ5hxW0eqSXVhes=
Message-ID: <49FE038F.2040704@gmail.com>
Date: Sun, 03 May 2009 14:50:23 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alex Buell <alex.buell@munted.org.uk>, Jeff Garzik <jeff@garzik.org>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
 question)
References: <E1LzLgA-0004j6-9W@closure.thunk.org> <49F90CA2.4080602@garzik.org> <20090430083309.437f9248@lithium.local.net> <49F95719.10701@kernel.org> <20090430144702.46415b90@lxorguk.ukuu.org.uk> <20090430153508.GA10704@linux.intel.com> <20090430154701.GA27737@srcf.ucam.org> <49FA5519.9000107@gmail.com> <49FCFC5D.5050303@kernel.org>
In-Reply-To: <49FCFC5D.5050303@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Robert Hancock wrote:
>> Matthew Garrett wrote:
>>> On Thu, Apr 30, 2009 at 08:35:08AM -0700, Matthew Wilcox wrote:
>>>> On Thu, Apr 30, 2009 at 02:47:02PM +0100, Alan Cox wrote:
>>>>>> So, at the point of driver load, there just isn't much we can do about
>>>>>> the missing ABAR.  It's sad.  Dunno why some laptop manufacturers
>>>>>> still program the thing into piix mode.  :-(
>>>>> Forcing out of PIIX mode would need to go into the PCI quirks and be a
>>>>> boot option not a module one - at that point its doable as a header
>>>>> quirk.
>>>> I think Matthew Garrett already has code to do this.
>>> Yeah, but some testers reported that it broke after using it for a
>>> while. The most recent version I have is this:
>> We should likely have something like this in the kernel, but it should
>> default to off. For one thing, some machines seem to have BIOS code that
>> tries to poke the controller for some reason during suspend/shutdown
>> events, etc. which would likely go nuts if the controller was
>> unexpectedly in AHCI mode..
> 
> Maybe, I don't know.  Matthew's patch seems clean enough for upstream
> inclusion but I'm always a bit put off about including some feature
> which should default to off.  It never gets used and tested a lot thus
> ending up broken on many configurations further fueling the vicious
> cycle.  After the initial interested users passed, it just becomes
> dead weight none uses which often is quite annoying when trying to
> change code around it because nobody at that point knows on which
> configurations it worked and even whether it not working is a
> regression or expected behavior.

Well, it's a potential concern, but it's simple enough I doubt it would 
really result in much of a burden. Having the force-AHCI option in place 
would allow those interested to try it more easily and see just how 
widely this can be done without breaking things.. It all really depends 
on the BIOS implementation.

> 
> Given the wide variety of ich motherboards out in the wild and all
> their different BIOS revisions and the fact that NCQ or not doesn't
> make whole lot of difference for most desktop workload, I think why
> bother.  A few years back some vendors seemed to use it for product
> differentiation but nowadays it's just silly to disable ahci for that
> purpose.

