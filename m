Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbYCYNei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbYCYNei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYCYNeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:34:19 -0400
Received: from rtr.ca ([76.10.145.34]:4519 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbYCYNeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:34:17 -0400
Message-ID: <47E8FF58.8050209@rtr.ca>
Date: Tue, 25 Mar 2008 09:34:16 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Greg KH l <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
References: <47E875AD.1000901@rtr.ca> <alpine.LFD.1.00.0803242254020.2775@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803242254020.2775@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 24 Mar 2008, Mark Lord wrote:
>> The return value uses "unsigned long",
>> which on a 32-bit system limits drive offsets to 2TB.
> 
> One relevant question is: does anybody seriously care about the 
> combination of "32 bit" and "huge modern drives" any more?
> 
> Sure, we can add a 64-bit version that ends up being used only on 32-bit 
> systems, but quite frankly, I think the solution here is to just ignore 
> the issue and see if anybody really even cares.
> 
> Because quite frankly, the kind of people who buy modern 2TB drives 
> generally don't then couple them to CPU's that are five+ years old.
..

Yeah.  Except Dell will undoubtedly have them in desktops
within 2 years, and tons of people (myself included) still use
32-bit (K)Ubuntu on our systems, simply for the better binary 
compatibility that it is perceived to give with things like
browser plugins and stuff.

Using sysfs interfaces might be a good alternative,
if they were easier to use, but drives are not directly
accessible there using the dev_t value from stat(2).

Instead, software has to search everything inside /sys/block/
looking for a "dev" file whose contents match,
rather than just trying to access something like this:

   /sys/block/8:1/start
or
   /sys/block/majors/8/minors/1/start

Or any one of a number of similar ways to arrange it.

Cheers
