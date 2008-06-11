Return-Path: <linux-kernel-owner+w=401wt.eu-S1764744AbYFKRok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764744AbYFKRok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 13:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYFKRoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 13:44:32 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:31363 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751994AbYFKRoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 13:44:30 -0400
Message-ID: <48500ED4.3010808@panasas.com>
Date: Wed, 11 Jun 2008 20:43:48 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Benny Halevy <bhalevy@panasas.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] linux-staging tree created
References: <20080610190540.GA25066@kroah.com> <484F9A7B.4080004@panasas.com> <484F9FEA.7000407@panasas.com> <20080611162534.GD22134@kroah.com>
In-Reply-To: <20080611162534.GD22134@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2008 17:44:03.0619 (UTC) FILETIME=[BD256730:01C8CBEA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Jun 11, 2008 at 12:50:34PM +0300, Boaz Harrosh wrote:
>> Benny Halevy wrote:
>>> Greg,
>>>
>>> The OSD initiator (see
>>> http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=summary)
>>> looks in principle like a great fit for linux-staging.
>>>
>> The patches are not yet there, Benny. They are currently 
>> out-of-tree here:
>> http://git.open-osd.org/gitweb.cgi?p=osd-lib.git;a=summary
>>
>> It will take me until end of next week to separate them into
>> a consumable patchset. Which will also move them in-tree.
>>  
>>> What would be the mechanics of including it?
>>>
>> I want to send them to linux-scsi-ml and also To: Greg KH
>> Requesting to be included in "linux-staging tree". Is that
>> sufficient?
> 
> If they are to go into linux-scsi, why would you need/want them in the
> -staging tree as well?
> 

We're jumping the guns here a bit, but ...

The code is pretty stable and robust as far as the protocol and performance
is concerned, surly once I in-tree them, divide them into patches, prettify
comments, add file-headers, and checkpatch them.

But the bigger implications are not yet clear, and will need advise from
the list, which could take time. Mainly in regard to upper ULD and tests.
Currently there are 4 users for this code:
- pNFS-over-objects layout driver
- pNFS-over-objects Simple Server implementation (spNFS)
- OSDVFS - Virtual psuedo file system to access and debug OSD luns from user mode.
          (This is not the OSDFS from IBM which is a general FS over objects,
           but a direct representation of the OSD Lun to user mode)
- Testing

The first 3 are their own ULD and do not need a proper SCSI-ULD. With some
changes to sg.c they can manage with what we have now. The later is just
for debugging.

On the other hand a true OSD-ULD that exports /dev/osdx char and/or block
devices, has merits and future directions of it's own. And will eliminate
the need for changes in sg.c

So the mechanics are pretty much there but the direction is not clear, which
will govern the folders/exports/dependencies. But I'm not sure -staging tree
will help in any of that. I do have my git.open-osd.org exports and can manage
all that there. It could help in exposure and testing of the code.

> thanks,
> 
> greg k-h

Thanks
Boaz
