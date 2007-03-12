Return-Path: <linux-kernel-owner+w=401wt.eu-S965145AbXCLFjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965145AbXCLFjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 01:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965126AbXCLFjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 01:39:00 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:51659 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965119AbXCLFi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 01:38:59 -0400
Date: Mon, 12 Mar 2007 01:38:37 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: RSDL for 2.6.21-rc3- 0.29
In-reply-to: <200703111719.38514.kernel@kolivas.org>
To: linux-kernel@vger.kernel.org, amanda-hackers@amanda.org
Cc: Con Kolivas <kernel@kolivas.org>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck@vds.kolivas.org
Message-id: <200703120138.37667.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070311013506.GD10459@waste.org>
 <20070311040305.GT10394@waste.org> <200703111719.38514.kernel@kolivas.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007, Con Kolivas wrote:
>On Sunday 11 March 2007 15:03, Matt Mackall wrote:
>> On Sat, Mar 10, 2007 at 10:01:32PM -0600, Matt Mackall wrote:
>> > On Sun, Mar 11, 2007 at 01:28:22PM +1100, Con Kolivas wrote:
>> > > Ok I don't think there's any actual accounting problem here per se
>> > > (although I did just recently post a bugfix for rsdl however I
>> > > think that's unrelated). What I think is going on in the ccache
>> > > testcase is that all the work is being offloaded to kernel threads
>> > > reading/writing to/from the filesystem and the make is not getting
>> > > any actual cpu time.
>> >
>> > I don't see significant system time while this is happening.
>>
>> Also, it's running pretty much entirely out of page cache so there
>> wouldn't be a whole lot for kernel threads to do.
>
>Well I can't reproduce that behaviour here at all whether from disk or
> the pagecache with ccache, so I'm not entirely sure what's different at
> your end. However both you and the other person reporting bad behaviour
> were using ATI drivers. That's about the only commonality? I wonder if
> they do need to yield... somewhat instead of not at all.

I hate to say it Con, but this one seems to have broken the amanda-tar 
symbiosis.

I haven't tried a plain 21-rc3, so the problem may exist there, and in 
fact it did for 21-rc1, but I don't recall if it was true for -rc2.  But 
I will have a plain 21-rc3 running by tomorrow nights amanda run to test.

What happens is that when amanda tells tar to do a level 1 or 2, tar still 
thinks its doing a level 0.  The net result is that the tape is filled 
completely and amanda does an EOT exit in about 10 of my 42 dle's.  This 
is tar-1.15-1 for fedora core 6.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
While it may be true that a watched pot never boils, the one you don't
keep an eye on can make an awful mess of your stove.
		-- Edward Stevenson
