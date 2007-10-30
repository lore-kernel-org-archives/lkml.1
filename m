Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbXJ3Fro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbXJ3Fro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 01:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbXJ3Frh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 01:47:37 -0400
Received: from sandeen.net ([209.173.210.139]:23939 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbXJ3Frg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 01:47:36 -0400
Message-ID: <4726C577.9000209@sandeen.net>
Date: Tue, 30 Oct 2007 00:47:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: David Miller <davem@davemloft.net>, byron.bbradley@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: XFS Fails Quality Assurance Tests on ARM
References: <fb80ve$i5q$1@sea.gmane.org>	<20070830.213901.48806818.davem@davemloft.net> <p73ps12vxrl.fsf@bingen.suse.de>
In-Reply-To: <p73ps12vxrl.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> David Miller <davem@davemloft.net> writes:
> 
>> From: Byron Bradley <byron.bbradley@gmail.com>
>> Date: Fri, 31 Aug 2007 03:12:46 +0000 (UTC)
>>
>>> Anybody got any ideas of how we fix this?
>> I don't know how much testing XFS gets on ARM, but one thing that some
>> ARM chips have is D-cache aliasing problems and one thing XFS uses a
>> lot is virtual remapping of various data structures via vmap().
>>
>> This might be what is causing the problems.

Sorry, I lost the original to reply to, but stumbled on this thread
looking for something else.  :)

Anyway, from the assertion:

Assertion failed: (char *)sfep - (char *)sfp == dp->i_d.di_size, file:
fs/xfs/xfs_dir2_sf.c, line: 647 kernel BUG at fs/xfs/support/debug.c:82!

this is almost certainly a result of xfs_dir2_sf_off_t,
xfs_dir2_sf_hdr_t, and/or xfs_dir2_sf_entry_t or others not being
"properly" aligned on arm.

There was a patch floating around to "fix" it but it's not on-disk
compatible w/ x86 & friends, it just makes things consistent for arm.  I
think packing some of these structures would take care of it, but this
problem could use some attention & testing I think, it's been floating
around a long time.

-Eric
