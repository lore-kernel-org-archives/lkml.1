Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbZGMIyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbZGMIyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 04:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbZGMIyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 04:54:20 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:26359
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754083AbZGMIyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 04:54:19 -0400
Message-ID: <4A5AF637.3090405@panasas.com>
Date: Mon, 13 Jul 2009 11:54:15 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
References: <20090707150758.GA18075@infradead.org> <20090707154809.GH2714@wotan.suse.de> <20090707163042.GA14947@infradead.org> <20090708063225.GL2714@wotan.suse.de> <20090708104701.GA31419@infradead.org> <20090708123412.GQ2714@wotan.suse.de> <4A54C435.1000503@panasas.com> <20090709075100.GU2714@wotan.suse.de> <4A59A517.1080605@panasas.com> <20090712144717.GA18163@infradead.org> <20090713065917.GO14666@wotan.suse.de>
In-Reply-To: <20090713065917.GO14666@wotan.suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2009 08:54:19.0474 (UTC) FILETIME=[82508320:01CA0397]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2009 09:59 AM, Nick Piggin wrote:
> On Sun, Jul 12, 2009 at 10:47:18AM -0400, Christoph Hellwig wrote:
>> On Sun, Jul 12, 2009 at 11:55:51AM +0300, Boaz Harrosh wrote:
>>> I wish you would split it.
>>>
>>> one - helper to be called by converted file systems
>>>       (Which just ignores the ATTR_SIZE)
>>> second - to be set into .setattr which does the simple_setsize + above.
>>>
>>> More clear for FS users like me (and that ugly unmask of ATTR_SIZE)
>>>
>>> or it's just me?
>> Yeah, that seems be a lot cleaner.  But let's wait until we got
>> rid of ->truncate for all filesystems to have the bigger picture.
> 
> Agreed, if it is a common sequence / requirement for filesystems
> then of course I will not object to a helper to make things clearer
> or share code.
> 
> I would like to see inode_setattr renamed into simple_setattr, and
> then also .setattr made mandatory, so I don't like to cut code out
> of inode_setattr which makes it unable to be the simple_setattr
> after the old truncate code is removed.
> 

I thought you meant inode_setattr will go away. There will
only be simple_setattr() and inode_setattr_nosize()

For the time been simple_setattr() will also take care
of old ->truncate FSs. And in the absence of .setattr
simple_setattr() is called. Have I miss-understood?

again please tell me when all this is in effect I want
to do the conversion in exofs.

[BTW these changes are a life saver for me in regard to
the kind of things I need to do for pNFS-exports]

Thanks
Boaz
