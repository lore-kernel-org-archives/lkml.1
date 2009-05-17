Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZEQM7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZEQM7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 08:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZEQM6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 08:58:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50573 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZEQM6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 08:58:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A100977.1070506@s5r6.in-berlin.de>
Date: Sun, 17 May 2009 14:56:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ingo Molnar <mingo@elte.hu>, Martin Bammer <mrb74@gmx.at>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <20090517073327.GC1583@elte.hu> <200905171234.23436.rjw@sisk.pl>
In-Reply-To: <200905171234.23436.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday 17 May 2009, Ingo Molnar wrote:
>> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13321
>>> Subject		: kernel crash with NULL pointer when boot
>>> Submitter	: Martin Bammer <mrb74@gmx.at>
>>> Date		: 2009-05-16 12:37 (1 days old)
>>> References	: http://lkml.org/lkml/2009/5/16/100
>> that crash is in reiserfs_for_each_xattr(), during sys_unlink()'s 
>> xattr teardown.
>>
>> There's been a good deal of reiserfs changes in this cycle - some 
>> touch the xattr code as well. Some of them fairly late in the cycle,

(Also, the bug is reportedly a post -rc5 regression.)

>> in the last two weeks:
>>
>>  earth4:~/tip> gll v2.6.29..linus --since=two-weeks-ago fs/reiserfs/
>>  2a32ceb: Fix races around the access to ->s_options
>>  677c9b2: reiserfs: remove privroot hiding in lookup
>>  b82bb72: reiserfs: dont associate security.* with xattr files
>>  ab17c4f: reiserfs: fixup xattr_root caching
>>  edcc37a: Always lookup priv_root on reiserfs mount and keep it
>>  5a6059c: reiserfs: Expand i_mutex to enclose lookup_one_len
>>
>> Martin, you could try a blind revert of say ... ab17c4f, which looks 
>> the most suspect and which is also a rather large commit.
>>
>> Or/and you could try a bisect - perhaps accelerated via:
>>
>>    git bisect start fs/reiserfs/
> 
> I think there's a fix already for this in the works, but it hasn't been merged
> yet.  It looks like Jeff has just posted some reiserfs fixes. :-)

I'd say Martin should try Jeff's pending patches before a revert or 
before starting a bisection.  Either apply them from 
http://lkml.org/lkml/2009/5/17/6, or pull from
  git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git for-next
or wait for them to appear in Linus' tree...

I for one didn't test the post v2.6.30-rc5 changes to reiserfs, but I 
did try them _together_ with the four pending patches on a system with 
reiserfs root filesystem and extended attributes disabled in the config. 
Everything is fine here after almost a week uptime.
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
