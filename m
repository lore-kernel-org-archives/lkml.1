Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbXFXKK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbXFXKK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 06:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXFXKKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 06:10:17 -0400
Received: from esuna.co.uk ([83.223.102.198]:59047 "EHLO mail.esuna.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751412AbXFXKKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 06:10:15 -0400
Message-ID: <467E4301.2010009@esuna.co.uk>
Date: Sun, 24 Jun 2007 11:10:09 +0100
From: "Jay L. T. Cornwall" <jay@esuna.co.uk>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: (Last oops is Tainted: P) Re: 2.6.22-rc5: pdflush oops under
 heavy disk load
References: <467B12CA.5060405@esuna.co.uk> <467BE118.4090308@redhat.com> <467BE4F1.7040308@esuna.co.uk> <467D0EB0.9030100@esuna.co.uk> <20070623102318.1b4f3d24.akpm@linux-foundation.org> <E1I2OqK-0005VK-JF@flower>
In-Reply-To: <E1I2OqK-0005VK-JF@flower>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:

>> That sounds like a good theory: you're getting easily-hit oopses in one of
>> the kernel's most-used codepaths which hasn't chanbged much in a long
>> time.  So Something Odd Has Happened.

> Maybe this time it's just "Tainted: P"?

That'sthe NVIDIA module, which isn't doing much with X shut down
regardless. It was bad form to forget this, of course, but is unrelated
to the problem.

> And oops have no ext3, like prev. one.

I know. This isn't ext3 related and I'm fairly certain drivers/net/atl1
is trashing... something. Perhaps the page table because:

[  153.785325] Bad page state in process 'scp'
[  153.785327] page:ffff81000308d020 flags:0x0040ad41dc050845
mapping:53dfe57d17cc59cf mapcount:16885953 count:292554304
[  153.785329] Trying to fix it up, but a reboot is needed

This one dismisses a reference counting issue because the page data here
looks like garbage. And a panic in VLC, playing a video across the
network hits a similar problem:

[ 9194.281809]  [<ffffffff802849e3>] page_remove_rmap+0x53/0x110
[ 9194.281819]  [<ffffffff8027c32c>] unmap_vmas+0x4ec/0x7c0
[ 9194.281852]  [<ffffffff802807ac>] unmap_region+0xcc/0x170
[ 9194.281867]  [<ffffffff8028160a>] do_munmap+0x22a/0x2f0
[ 9194.281877]  [<ffffffff80439ee2>] __down_write_nested+0x12/0xb0
[ 9194.281892]  [<ffffffff802ef936>] sys_shmdt+0xb6/0x150
[ 9194.281903]  [<ffffffff80209e8e>] system_call+0x7e/0x83
[ 9194.281921]
[ 9194.281924]
[ 9194.281925] Code: 48 2b ba 98 21 00 00 48 c1 ff 03 48 0f af f8 48 03
ba a8 21
[ 9194.281973] RIP  [<ffffffff80271f99>] page_to_pfn+0x19/0x40

> Jay, check your oops against "Tainted: P" flag, which is not supported
> here, and not drop persons, who assisted you from the CC list.

My apologies, I had thought the etiquette was to only include
maintainers on the CC list.

I'll try and locate a maintainer for the Attansic driver a bit later,
but I've only seen people loosely related to it. In any case we may as
well let this thread die because it's not related to a filesystem bug
(which the CC list is presumably interested in).

-- 
Jay L. T. Cornwall, http://www.esuna.co.uk/~jay/
PhD Student
Imperial College London
