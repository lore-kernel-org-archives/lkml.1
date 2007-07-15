Return-Path: <linux-kernel-owner+w=401wt.eu-S1763186AbXGPAAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763186AbXGPAAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761465AbXGOX75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:59:57 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:54213
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760189AbXGOX7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:59:54 -0400
Date: Sun, 15 Jul 2007 16:53:47 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.44L0.0707151915570.28934-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.64.0707151650090.25614@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707151915570.28934-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007, Alan Stern wrote:

> On Sun, 15 Jul 2007 david@lang.hm wrote:
>
>>> (1) Filesystems mounted before the hibernation are untouchable
>>>
>>>    When there's a memory snapshot, either in the form of a hibernation image,
>>>    or in the form of the "old" kernel and processes available to the "new"
>>>    kexeced kernel responsible for saving their memory, the filesystems mounted
>>>    before the hibernation should not be accessed, even for reading, because
>>>    that would cause their on-disk state to be inconsistent with the snapshot
>>>    and might lead to a filesystem corruption.
>>
>> AFAIK this is only the case with ext3, all other filesystems could be
>> accessed read-only safely
>>
>> this is arguably a bug with ext3 (and has been discussed as such), but
>> right now the ext3 team has decided not to change this bahavior so
>> hibernate needs to work around it. but don't mistake a work-around for a
>> single (admittedly very popular) filesystem with a hard and fast
>> directive.
>
> Isn't is possible to avoid this problem by mounting an ext3 filesystem
> as readonly ext2?  Provided the filesystem isn't dirty it should be
> doable.  (And provided the filesystem doesn't use any ext3 extensions
> that are incompatible with ext2.)

from the last discussion I saw on the kernel mailing list, no. the act of 
mounting the ext3 filesystem as ext2 read-only will change it as the 
unsupported extentions get turned off (and I think the journal contents at 
least are lost as part of this)

David Lang
