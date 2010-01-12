Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679Ab0ALJWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab0ALJWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648Ab0ALJWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:22:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54473 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab0ALJWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:22:44 -0500
To: Dave Chinner <david@fromorbit.com>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: 2.6.33-rc3 -- INFO: possible recursive locking -- (s_active){++++.+}, at: [<c10d2941>] sysfs_hash_and_remove+0x3d/0x4f
References: <a44ae5cd1001060454g22fb5a0ay8185bc680cd4fc67@mail.gmail.com>
	<2375c9f91001100058w4bac1cf9s183fc37eafbfde75@mail.gmail.com>
	<m13a2dho1o.fsf@fess.ebiederm.org> <201001101935.31882.rjw@sisk.pl>
	<m1wrzpbcmi.fsf@fess.ebiederm.org> <4B4BC2D3.7070003@kernel.org>
	<m11vhw6u3k.fsf@fess.ebiederm.org>
	<20100112030134.GA17483@discord.disaster>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 12 Jan 2010 01:22:31 -0800
In-Reply-To: <20100112030134.GA17483@discord.disaster> (Dave Chinner's message of "Tue\, 12 Jan 2010 14\:01\:34 +1100")
Message-ID: <m1bpgz8yp4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Mon, Jan 11, 2010 at 04:32:31PM -0800, Eric W. Biederman wrote:
>> Tejun Heo <tj@kernel.org> writes:
>> 
>> > On 01/11/2010 11:26 AM, Eric W. Biederman wrote:
>> >> From: Eric W. Biederman <ebiederm@xmission.com>
>> >> Date: Sun, 10 Jan 2010 18:13:35 -0800
>> >> Subject: [PATCH] sysfs: Add support for lockdep subclasses to s_active
>> >> 
>> >> We have apparently valid cases where the code for a sysfs attribute
>> >> removes other sysfs attributes.  Without support for subclasses
>> >> lockdep flags a possible recursive lock problem as it figures
>> >> the first sysfs attribute could be attempting to remove itself.
>> >> 
>> >> By adding support for sysfs subclasses we can teach lockdep to
>> >> distinguish between different types of sysfs attributes and not
>> >> get confused.
>> >> 
>> >> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> >
>> > Acked-by: Tejun Heo <tj@kernel.org>
>> 
>> Now if I can just get a Tested-by  this patch will be all set ;)
>
> Hi Eric,
>
> Is this the same locking problem that this patch fixes?
>
> http://lkml.org/lkml/2010/1/11/26

It certainly looks similar.   The sysfs file that is being written
is different so I can't tell if that is a false positive because
sysfs is used for everything, or if it is a real issue.

Eric
