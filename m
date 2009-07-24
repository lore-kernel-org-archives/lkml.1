Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbZGXFHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbZGXFHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 01:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZGXFHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 01:07:36 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:39496 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbZGXFHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 01:07:32 -0400
X-Greylist: delayed 2011 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2009 01:07:32 EDT
Message-ID: <4A6939F2.3050006@xenontk.org>
Date: Fri, 24 Jul 2009 10:04:58 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2 ThunderBrowse/3.2.6.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Linux 2.6.31-rc4: strange change in iomem allocation
References: <alpine.LFD.2.01.0907221936220.3352@localhost.localdomain> <200907231614.23570.elendil@planet.nl> <200907231653.48933.elendil@planet.nl> <alpine.LFD.2.01.0907230905360.21520@localhost.localdomain> <alpine.LFD.2.01.0907230926140.21520@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0907230926140.21520@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2009 09:59 PM, Linus Torvalds wrote:
> 
> On Thu, 23 Jul 2009, Linus Torvalds wrote:
>> Don't worry about the new warning. 
>>
>> It is in fact _normal_ to see a number of warnings about PnP resources 
>> "could not be reserved"
> 
> In fact, I notice that you had them even before, eg:
> 
> 	system 00:00: iomem range 0x0-0x9ffff could not be reserved
> 	system 00:00: iomem range 0xe0000-0xfffff could not be reserved
> 	system 00:00: iomem range 0x100000-0x7e7fffff could not be reserved
> 
> which are about exactly the same thing - e820 RAM reservations take 
> precedence over the PnP ones.
> 
> So the only new thing is that we claim the APIC thing to that category 
> too.
> 

If the kernel knows that those ranges have already been reserved, can't
the PnP messages be suppressed? I used to think these were errors as
well (because of some BIOS misbehaviour) until I checked the code...
