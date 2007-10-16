Return-Path: <linux-kernel-owner+w=401wt.eu-S965727AbXJPXs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965727AbXJPXs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934180AbXJPXst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:48:49 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50394 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779AbXJPXss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:48:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch][rfc] rewrite ramdisk
References: <200710151028.34407.borntraeger@de.ibm.com>
	<200710161747.12968.nickpiggin@yahoo.com.au>
	<20071016212853.GB1314@closure.lan>
	<200710170808.30944.nickpiggin@yahoo.com.au>
Date: Tue, 16 Oct 2007 17:48:01 -0600
In-Reply-To: <200710170808.30944.nickpiggin@yahoo.com.au> (Nick Piggin's
	message of "Wed, 17 Oct 2007 08:08:30 +1000")
Message-ID: <m1ve96fwpa.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Wednesday 17 October 2007 07:28, Theodore Tso wrote:
>> On Tue, Oct 16, 2007 at 05:47:12PM +1000, Nick Piggin wrote:
>> > +	/*
>> > +	 * ram device BLKFLSBUF has special semantics, we want to actually
>> > +	 * release and destroy the ramdisk data.
>> > +	 */
>>
>> We won't be able to fix completely this for a while time, but the fact
>> that BLKFLSBUF has special semantics has always been a major wart.
>> Could we perhaps create a new ioctl, say RAMDISKDESTORY, and add a
>> deperecation printk for BLKFLSBUF when passed to the ramdisk?  I doubt
>> there are many tools that actually take advantage of this wierd aspect
>> of ramdisks, so hopefully it's something we could remove in a 18
>> months or so...
>
> It would be nice to be able to do that, I agree. The new ramdisk
> code will be able to flush the buffer cache and destroy its data
> separately, so it can actually be implemented.

So the practical problem are peoples legacy boot setups but those
are quickly going away.

The sane thing is probably something that can be taken as a low
level format command for the block device.

Say: dd if=/dev/zero of=/dev/ramX

I know rewriting the drive with all zeroes can cause a modern
disk to redo it's low level format.  And that is something
we can definitely implement without any backwards compatibility
problems.

Hmm. Do we have anything special for punching holes in files?
That would be another sane route to take to remove the special
case for clearing the memory.

Eric

