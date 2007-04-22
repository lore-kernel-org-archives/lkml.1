Return-Path: <linux-kernel-owner+w=401wt.eu-S965635AbXDVK2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635AbXDVK2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 06:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965641AbXDVK2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 06:28:54 -0400
Received: from as1.cineca.com ([130.186.84.251]:57572 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965635AbXDVK2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 06:28:53 -0400
Message-ID: <462B38D7.1060000@cineca.it>
From: Andrea Righi <a.righi@cineca.it>
Reply-To: a.righi@cineca.it
Organization: CINECA
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Jeff Mahoney <jeffm@suse.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>, linux-kernel@vger.kernel.org,
       reiserfs-dev@namesys.com, Edward Shishkin <edward@namesys.com>,
       zam@clusterfs.com, ak@suse.de
Subject: Re: [PATCH] reiserfs: fix xattr root locking/refcount bug
References: <20070413095219.02075323.akpm@linux-foundation.org>	<462536B2.5060308@users.sourceforge.net>	<c04ebacf0704180152qdc72fcdnd0755dbf070b40d2@mail.gmail.com>	<200704181816.21166.vs@namesys.com>	<46263270.9010108@suse.com>	<20070420170738.e269fcae.akpm@linux-foundation.org>	<46296CB8.3090100@suse.com>	<462A0F06.9020602@cineca.it>	<462A2055.1040509@suse.com>	<462A2107.6060902@suse.de>	<462A2D27.3060809@suse.com> <20070421123956.f74575d0.akpm@linux-foundation.org>
In-Reply-To: <20070421123956.f74575d0.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Sun, 22 Apr 2007 12:28:40 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 21 Apr 2007 11:26:31 -0400 Jeff Mahoney <jeffm@suse.com> wrote:
> 
>>  The listxattr() and getxattr() operations are only protected by a read
>>  lock. As a result, if either of these operations run in parallel, a race
>>  condition exists where the xattr_root will end up being cached twice,
>>  which results in the leaking of a reference and a BUG() on umount.
>>
>>  This patch refactors get_xa_root(), __get_xa_root(), and
>>  create_xa_root(), into one get_xa_root() function that takes
>>  the appropriate locking around the entire critical section.
> 
> Great, thanks.
> 
> Now we need to work out the timing.  Our options are to shove
> it into 2.6.21 immediately, or to give it a run in 2.6.22-rc1 then
> backport into 2.6.21.x.
> 
> What is everyone's confidence level?
> 

Tested the patch and I confirm that it fixes the problem. Regarding the
confidence level, in my case I can say that on a suse 10.0 I can always
reproduce the bug on every shutdown. Anyway, I'm not using the default
kernel shipped with suse 10.0, but maybe the same bug could be seen in
opensuse 10.3 that (if I'm not wrong) uses a 2.6.20.

BTW there are not enough details, but a similar problem seems to be
already reported here: https://bugzilla.novell.com/show_bug.cgi?id=259215

-Andrea
