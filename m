Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbZG1RJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbZG1RJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbZG1RJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:09:15 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:52615 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbZG1RJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:09:14 -0400
Message-ID: <4A6F30AF.4000004@mnementh.co.uk>
Date: Tue, 28 Jul 2009 18:09:03 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
       akpm@linux-foundation.org, Matt Fleming <matt@console-pimps.org>,
       Philip Langdale <philipl@overt.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] tmio_mmc: Optionally support using platform clock
References: <Pine.LNX.4.64.0907280937000.4943@axis700.grange> <4A6F0123.9040809@mnementh.co.uk> <Pine.LNX.4.64.0907281556160.6219@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0907281556160.6219@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:

> Hi Ian

Hi!

> Thanks for the review.

No problem - I hope you dont feel that I am picking on you in particular 
here, this problem is not isolated to your patches.

> I understand your concerns. Of course, the _proper_ solution would be to 
> implement an architecture-independent clock API, something like what 
> clocklib was trying to do. So, yes, if clocklib were in place now, I 
> certainly would have used it.

Which is of course a chicken/egg situation. I dealt with this a number 
of times during the e-series development, and every time, integration 
with mainline has gone more swiftly and with better quality, when the 
job was done properly to begin with.

> I searched for those clocklib submission attempts (Dmitry added to CC). 

Also adding RMK to the CC:

> Last one I can find (maybe I missed some) is from July 2008 - more than a 
> year ago. So, looks like our options currently are:
> 
> 1. wait for new submissions of clocklib - if any are planned

Dmitry: whats the current status of your clocklib work?

> 2. develop a completely new arch-independent clock API approach

No chance.

> 3. take over patches from Dmitry and bring them to a state acceptable for 
> mainline

Take over / collaborate with. I'll happily help people push these patches.

> I personally don't have free (as in beer) time to work on 2 or 3. Anyone?

If I can find out what the current state of this stuff is, I'll help get 
it working - I can test / update all the TC6x and T7x MFD devices (and 
probably asic3 too)

> So, unless we hear, that one of the 1-3 is going to happen real soon now, 
> I think, it would be unfair to leave SuperH without a proper MMC driver in 
> the mainline for an indefinite time, when one can be trivially achieved.

Yes, because listening makes code write itself...

If the changes are so trivial, it wont hurt to maintain them as a patch. 
certainly tmio-mmc doesnt change very rapidly so the patch wont need 
regenerating much. You already have this patchset.

So since thats taken care of, we're all now free to work on updating 
the clock API. And once thats done, you can drop your patch and add one 
line to create / alias the clock in your superH platform code.

> As for your debugging concern, we could allow configuration-less operation 
> only on SuperH in tmio_mmc, how about that?

No. The correct way to support optional parts of the hardware is to 
simply not access them when they are not there.

As I said, I'll happily take a patch to abstract power control for the 
tmio-mmc driver. This should remove most of the config area accesses 
from the driver (and shrink your patch!). The remainder are all about 
clock config, and will disappear once we sort the clock API.

Mainline isn't about 'fair' its about 'right'.

-Ian
