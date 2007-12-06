Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbXLFIi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbXLFIi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 03:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbXLFIh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 03:37:59 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44839 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbXLFIh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 03:37:58 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Giacomo Catenazzi <cate@cateee.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: proc/bus.usb regression in : [NETNS]: Fix /proc/net breakage
References: <200712031900.lB3J0PR9025742@hera.kernel.org>
	<20071205040236.ff102b9e.akpm@linux-foundation.org>
	<4757B121.6000308@cateee.net>
Date: Thu, 06 Dec 2007 01:36:38 -0700
In-Reply-To: <4757B121.6000308@cateee.net> (Giacomo Catenazzi's message of
	"Thu, 06 Dec 2007 09:21:53 +0100")
Message-ID: <m1k5nste21.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giacomo Catenazzi <cate@cateee.net> writes:

> Andrew Morton wrote:
>> On Mon, 3 Dec 2007 19:00:25 GMT Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
>> 
>>> Gitweb:
> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2b1e300a9dfc3196ccddf6f1d74b91b7af55e416
>>> Commit:     2b1e300a9dfc3196ccddf6f1d74b91b7af55e416
>>> Parent:     e03ba84adb62fbc6049325a5bc00ef6932fa5e39
>>> Author:     Eric W. Biederman <ebiederm@xmission.com>
>>> AuthorDate: Sun Dec 2 00:33:17 2007 +1100
>>> Committer:  Herbert Xu <herbert@gondor.apana.org.au>
>>> CommitDate: Sun Dec 2 00:33:17 2007 +1100
>>>
>>>     [NETNS]: Fix /proc/net breakage
>>>     
>>>     Well I clearly goofed when I added the initial network namespace support
>>> for /proc/net.  Currently things work but there are odd details visible to
>>>     user space, even when we have a single network namespace.
>>>     
>>>     Since we do not cache proc_dir_entry dentries at the moment we can just
>>>     modify ->lookup to return a different directory inode depending on the
>>>     network namespace of the process looking at /proc/net, replacing the
>>>     current technique of using a magic and fragile follow_link method.
>>>     
>>>     To accomplish that this patch:
>>>     - introduces a shadow_proc method to allow different dentries to
>>>       be returned from proc_lookup.
>>>     - Removes the old /proc/net follow_link magic
>>>     - Fixes a weakness in our not caching of proc generic dentries.
>>>     
>>> As shadow_proc uses a task struct to decided which dentry to return we can
>>> go back later and fix the proc generic caching without modifying any code
>>>     that uses the shadow_proc method.
>> 
>> This patch caused the binfmt_misc regression reported in
>> http://bugzilla.kernel.org/show_bug.cgi?id=9504
>
> This patch also doesn't allow to mount /proc/bus/usb

Agreed.

Strictly speaking the mounts work but we just can't find them.
It is equally bad either way.

Eric
