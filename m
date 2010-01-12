Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374Ab0ALDCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0ALDCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 22:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691Ab0ALDCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 22:02:41 -0500
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:34156 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752610Ab0ALDCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 22:02:41 -0500
Date: Tue, 12 Jan 2010 14:01:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: 2.6.33-rc3 -- INFO: possible recursive locking --
	(s_active){++++.+}, at: [<c10d2941>] sysfs_hash_and_remove+0x3d/0x4f
Message-ID: <20100112030134.GA17483@discord.disaster>
References: <a44ae5cd1001060454g22fb5a0ay8185bc680cd4fc67@mail.gmail.com> <2375c9f91001100058w4bac1cf9s183fc37eafbfde75@mail.gmail.com> <m13a2dho1o.fsf@fess.ebiederm.org> <201001101935.31882.rjw@sisk.pl> <m1wrzpbcmi.fsf@fess.ebiederm.org> <4B4BC2D3.7070003@kernel.org> <m11vhw6u3k.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11vhw6u3k.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 04:32:31PM -0800, Eric W. Biederman wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
> > On 01/11/2010 11:26 AM, Eric W. Biederman wrote:
> >> From: Eric W. Biederman <ebiederm@xmission.com>
> >> Date: Sun, 10 Jan 2010 18:13:35 -0800
> >> Subject: [PATCH] sysfs: Add support for lockdep subclasses to s_active
> >> 
> >> We have apparently valid cases where the code for a sysfs attribute
> >> removes other sysfs attributes.  Without support for subclasses
> >> lockdep flags a possible recursive lock problem as it figures
> >> the first sysfs attribute could be attempting to remove itself.
> >> 
> >> By adding support for sysfs subclasses we can teach lockdep to
> >> distinguish between different types of sysfs attributes and not
> >> get confused.
> >> 
> >> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> >
> > Acked-by: Tejun Heo <tj@kernel.org>
> 
> Now if I can just get a Tested-by  this patch will be all set ;)

Hi Eric,

Is this the same locking problem that this patch fixes?

http://lkml.org/lkml/2010/1/11/26

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
