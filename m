Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbZECCHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbZECCHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 22:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZECCHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 22:07:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:55433 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZECCHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 22:07:44 -0400
Message-ID: <49FCFC5D.5050303@kernel.org>
Date: Sun, 03 May 2009 11:07:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alex Buell <alex.buell@munted.org.uk>, Jeff Garzik <jeff@garzik.org>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
   question)
References: <E1LzLgA-0004j6-9W@closure.thunk.org> <49F90CA2.4080602@garzik.org> <20090430083309.437f9248@lithium.local.net> <49F95719.10701@kernel.org> <20090430144702.46415b90@lxorguk.ukuu.org.uk> <20090430153508.GA10704@linux.intel.com> <20090430154701.GA27737@srcf.ucam.org> <49FA5519.9000107@gmail.com>
In-Reply-To: <49FA5519.9000107@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 03 May 2009 02:06:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Matthew Garrett wrote:
>> On Thu, Apr 30, 2009 at 08:35:08AM -0700, Matthew Wilcox wrote:
>>> On Thu, Apr 30, 2009 at 02:47:02PM +0100, Alan Cox wrote:
>>>>> So, at the point of driver load, there just isn't much we can do about
>>>>> the missing ABAR.  It's sad.  Dunno why some laptop manufacturers
>>>>> still program the thing into piix mode.  :-(
>>>> Forcing out of PIIX mode would need to go into the PCI quirks and be a
>>>> boot option not a module one - at that point its doable as a header
>>>> quirk.
>>> I think Matthew Garrett already has code to do this.
>>
>> Yeah, but some testers reported that it broke after using it for a
>> while. The most recent version I have is this:
> 
> We should likely have something like this in the kernel, but it should
> default to off. For one thing, some machines seem to have BIOS code that
> tries to poke the controller for some reason during suspend/shutdown
> events, etc. which would likely go nuts if the controller was
> unexpectedly in AHCI mode..

Maybe, I don't know.  Matthew's patch seems clean enough for upstream
inclusion but I'm always a bit put off about including some feature
which should default to off.  It never gets used and tested a lot thus
ending up broken on many configurations further fueling the vicious
cycle.  After the initial interested users passed, it just becomes
dead weight none uses which often is quite annoying when trying to
change code around it because nobody at that point knows on which
configurations it worked and even whether it not working is a
regression or expected behavior.

Given the wide variety of ich motherboards out in the wild and all
their different BIOS revisions and the fact that NCQ or not doesn't
make whole lot of difference for most desktop workload, I think why
bother.  A few years back some vendors seemed to use it for product
differentiation but nowadays it's just silly to disable ahci for that
purpose.

Thanks.

-- 
tejun
