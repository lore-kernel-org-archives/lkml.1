Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbYJMRa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbYJMRa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 13:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbYJMRas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 13:30:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45858 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367AbYJMRar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 13:30:47 -0400
Message-ID: <48F385B5.1040503@redhat.com>
Date: Mon, 13 Oct 2008 13:30:29 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Stefan Monnier <monnier@iro.umontreal.ca>, linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org> <48ED1D62.8080100@redhat.com> <20081012143505.GA15799@logfs.org>
In-Reply-To: <20081012143505.GA15799@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Wed, 8 October 2008 16:51:46 -0400, Chris Snook wrote:
>> Stefan Monnier wrote:
>>
>> Writes to magnetic disks are functionally atomic at the sector level.  With 
>> SSDs, writing requires an erase followed by rewriting the sectors that 
>> aren't changing.  This means that an ill-timed power loss can corrupt an 
>> entire erase block, which could be up to 256k on some MLC flash.  Unless 
> 
> What makes you think that?  The standard mode of operation in El Cheapo
> devices is to write to a new eraseblock first, then delete the old one.
> An ill-timed power loss results in either the old or the new block being
> valid as a whole.  This has been the standard ever since you could buy
> 4MB compactflash cards. 
> 
>> logfs tries to solve the write amplification problem by forcing all write 
>> activity to be sequential.  I'm not sure how mature it is.
> 
> Still under development.  What exactly do you mean by the write
> amplification problem?

Write amplification is where a 512 byte write turns into a 128k write, 
due to erase block size.

>>> Or is there some hope for SSDs to provide access to the MTD layer in the
>>> not too distant future?
>> I hope not.  The proper fix is to have the devices report their physical 
>> topology via SCSI/ATA commands.  This allows dumb software to function 
>> correctly, albeit inefficiently, and allows smart software to optimize 
>> itself. This technique also helps with RAID arrays, large-sector disks, etc.
> 
> Having access to the actual flash would provide a large number of
> benefits.  It just isn't a safe default choice at the moment.
> 
>> I suspect that in the long run, the problem will go away.  Erase blocks are 
>> a relic of the days when flash was used primarily for low-power, 
>> read-mostly applications.  As the SSD market heats up, the flash vendors 
>> will move to smaller erase blocks, possibly as small as the sector size.  
> 
> Do you have any information to back this claim?  AFAICT smaller erase
> blocks would require more chip area per bit, making devices more
> expensive.  If anything, I can see a trend towards bigger erase blocks.

Intel is claiming a write amplification factor of 1.1.  Either they're 
using very small erase blocks, or doing something very smart in the 
controller.

-- Chris
