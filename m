Return-Path: <linux-kernel-owner+w=401wt.eu-S935732AbXGLWJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935732AbXGLWJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 18:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760002AbXGLWJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 18:09:16 -0400
Received: from [72.243.156.19] ([72.243.156.19]:33202 "EHLO
	mail.automation-pros.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756527AbXGLWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 18:09:16 -0400
X-Greylist: delayed 1681 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 18:09:16 EDT
Message-ID: <46969FF1.2030809@turmel.org>
Date: Thu, 12 Jul 2007 17:41:05 -0400
From: Phil Turmel <pturmel-kernel@turmel.org>
User-Agent: Mozilla Thunderbird 1.0.6 (Windows/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: LinuxKernel@jamesplace.net
CC: linux-kernel@vger.kernel.org
Subject: Re: Problem recovering a failed RIAD5 array with 4-drives.
References: <200707120849.16068.LinuxKernel@jamesplace.net> <20070712164400.GD31195@csclub.uwaterloo.ca> <200707121521.21407.LinuxKernel@jamesplace.net>
In-Reply-To: <200707121521.21407.LinuxKernel@jamesplace.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James wrote:
[snip /]
>>On Thu, Jul 12, 2007 at 08:49:15AM -0500, James wrote:
>>>I've tried a few cautions things to bring the array back up with the three 
>>>good drives with no luck. 
>>>
[snip /]
> 
> mdadm --create --verbose /dev/md0 --assume-clean --level=raid5 --raid-devices=4 --spare-devices=0  /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
> 
[snip /]
> 
> I should have included more information. When I attempted to --assemble the 
> array I received the following:
> 
> []# mdadm --assemble [--force --run] /dev/md0 /dev/sda1 /dev/sdb1 
> [/dev/sdc1]  /dev/sdd1
> mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
> 
> 
> From what I read I assumed I could use the --assume-clean option with --create 
> to bring the array back at least in some semblance of working order. 
> 
> I'd like to recover as much as possible from the RAID array. I actually have a 
> nice new SATA configuration sitting here waiting to receive the data. This 
> thing failed a day too early. I'm gnashing my teeth over this one. 
> 
> I'd truly appreciate any help/advice.
> 
Hi James,

mdadm allows you to specify "missing" in place of a failed device 
when assembling or creating arrays, like so:

mdadm --assemble /dev/md0 --run \
	/dev/sda1 /dev/sdb1 missing /dev/sdd1

I don't know if using --create has already trashed your array, 
but this is worth a try.  You may also want to try --force with 
the above.

HTH,

Phil

