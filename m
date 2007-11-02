Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbXKBKu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbXKBKu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 06:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbXKBKuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 06:50:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64426 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbXKBKuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 06:50:11 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [AppArmor 19/45] Add struct vfsmount parameters to vfs_rename()
To: Al Viro <viro@ftp.linux.org.uk>, John Johansen <jjohansen@suse.de>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>
Reply-To: 7eggert@gmx.de
Date: Fri, 02 Nov 2007 11:14:14 +0100
References: <9irkY-83N-5@gated-at.bofh.it> <9iruz-7b-23@gated-at.bofh.it> <9irXD-Jf-25@gated-at.bofh.it> <9iC6y-nT-1@gated-at.bofh.it> <9iE8n-3zk-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1IntXa-0001JL-Qw@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX195ma/IP8u2n91/UdV4WfGYq8ARzzOgscF6emK
 BXFD6CuZQElZ3MDhzA8+hyU1/CR21HDcJV1JBeBAuzkFv3YYxP
 Rikb9dgiOMtpS3karFrVQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> wrote:
> On Fri, Oct 26, 2007 at 11:23:53AM -0700, John Johansen wrote:

>> In the current code, both vfsmounts are always identical, and so one of
>> the two should go, agreed.
>> 
>> The thought behind passing both vfsmounts was that they could differ but
>> point to the same super_block, in which case renames would still be
>> possible at least from a filesystem point of view. The essential
>> restriction here is that both files must be on the same device; the vfs
>> restriction of not allowing cross-mount renames is arbitrary.
> 
> It's called "access control".  Pathname-based one, BTW.  And yes, it's
> 100% deliberate.

I doubt anybody uses bind mounts & co instead of symlinks in order to
prevent rename() while still allowing to move files by either copying
or by using the source file in the bound directory. At least I expected
bind mounted directories to behave like symlinked ones, minus the problems
of symlinks. 

Since this feature only protects you from rename(src/foo,dst/foo) if
1) There is no way to access src and dst in the same mount space
2) src and dst are writebale by the attacker
3) Unlinking src/foo is OK
4) Renaming src/foo is OK as long as it's within the same mount as foo
5) Symlinking src/foo to dst/foo is OK
6) Creating dst/foo having a different owner is OK
7) Having dst/foo with the original content and owner from src/foo is _not_ OK
8) Moon crashes on earth
, I'd rather like to have a fast mv.

>> Cross-mount renames are not allowed currently, and granted, they may not
>> be very useful, either.
> 
> <raised brows>
> Excuse me, but IIRC LSM was supposed to _add_ restrictions, not to remove
> existing security checks.

Security checks as in "we built a steel door into that Chinese paper wall"?

As far as I understand, the restriction would not be removed by the LSM
explicitely allowing it, but by the fixed vfs then being able to handle
cross-mountpoint-renames. Maybe yo'll want to keep the ability for the users
who use bind mounts in order to not allow rename() ... both of them.-)

/me prepares for the impact of a large round object on earth.

