Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbZAEEb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbZAEEb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 23:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZAEEbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 23:31:46 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:10614 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZAEEbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 23:31:44 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=7AcagaR9O5AMzD1mRjcA:9 a=ilPceNvj0vWUAslt1AAA:7 a=t3q3Ah_175LQi408jVwMQWuLDOsA:4
Message-ID: <49618D2C.3090004@shaw.ca>
Date: Sun, 04 Jan 2009 22:31:40 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.documentation,gmane.linux.kernel
To: Rob Landley <rob@landley.net>
CC: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@suse.cz>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Duane Griffin <duaneg@dghda.com>,
       Valdis.Kletnieks@vt.edu,
       =?windows-1252?Q?Martin_MOKREJ=8A?= 
	<mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no> <20090104224052.GE1913@elf.ucw.cz> <20090104233052.GG22958@mit.edu> <200901042149.27655.rob@landley.net>
In-Reply-To: <200901042149.27655.rob@landley.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> On Sunday 04 January 2009 17:30:52 Theodore Tso wrote:
>> On Sun, Jan 04, 2009 at 11:40:52PM +0100, Pavel Machek wrote:
>>> Not neccessarily.
>>>
>>> If I have a bit of precious data and lot of junk on the card, I want
>>> to copy out the precious data before the card dies. Reading the whole
>>> media may just take too long.
>>>
>>> That's probably very true for rotating harddrives after headcrash...
>> For a small amount data, maybe; but the number of seeks is often far
>> more destructive than the amount of time the disk is spinning.  And in
>> practice, what generally happens is the user starts looking around to
>> make sure there wasn't anything else on the disk worth saving, and now
>> data is getting copied off based on human reaction time.  So that's
>> why I normally advise users that doing a full image copy of the disk
>> is much better than, say, "cp -r /home/luser /backup", or cd'ing
>> around a filesystem hierarchy and trying to save files one by one.
> 
> That would be true if the disk hardware wasn't doing a gazillion retries to 
> read a bad sector internally (taking 5 seconds to come back and report 
> failure), and then the darn scsi layer added another gazillion retries on top 
> of that, and the two multiply together to make it so slow that that when you 
> leave the thing copying the disk overnight it's STILL not done 24 hours later.  
> Going in and cherry picking individual files looks kind of appealing in that 
> situation.
> 
> Rob
> 
> P.S. Yeah, I had a laptop hard drive crash a month or so back.  I remember 
> when it was still possible to buy storage devices that didn't get arbitrarily 
> routed through the SCSI layer.  I miss those days.  I found the patch to route 
> ramdisks through the scsi layer amusing, though.

SCSI layer doesn't do any retries itself. Block layer does.

Even with zero software retries however, if there are a ton of bad 
sectors it can still take ages for them to all fail reading one at a 
time just from the disk's retries..
