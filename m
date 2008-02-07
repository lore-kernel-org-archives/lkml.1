Return-Path: <linux-kernel-owner+w=401wt.eu-S933055AbYBGA4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbYBGA4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934660AbYBGAw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:52:58 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39207 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934653AbYBGAw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:52:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Holger Schurig <hs4233@mail.mn-solutions.de>,
       linux-kernel@vger.kernel.org
Subject: Re: OOPS in sysctl.c
References: <200802050845.58691.hs4233@mail.mn-solutions.de>
	<200802051224.56413.hs4233@mail.mn-solutions.de>
	<20080206002420.91124dab.akpm@linux-foundation.org>
	<20080206190353.GB1732@martell.zuzino.mipt.ru>
Date: Wed, 06 Feb 2008 17:51:43 -0700
In-Reply-To: <20080206190353.GB1732@martell.zuzino.mipt.ru> (Alexey Dobriyan's
	message of "Wed, 6 Feb 2008 22:03:53 +0300")
Message-ID: <m1myqdd1wg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> On Wed, Feb 06, 2008 at 12:24:20AM -0800, Andrew Morton wrote:
>> On Tue, 5 Feb 2008 12:24:56 +0100 Holger Schurig <hs4233@mail.mn-solutions.de>
> wrote:
>> 
>> > > I have an embedded target (PXA255 based) where I have a nice
>> > > running kernel 2.6.15. Today I'm trying to get 2.6.24 running
>> > > on it.
>> > 
>> 
>> Backtrace:
>> [<c0038bbc>] (sysctl_head_next+0x0/0x64) from [<c00a4b80>]
> (proc_sys_readdir+0x360/0x394)
>>  r4:00000000
>> [<c00a4820>] (proc_sys_readdir+0x0/0x394) from [<c007c860>]
> (vfs_readdir+0x70/0x98)
>> [<c007c7f0>] (vfs_readdir+0x0/0x98) from [<c007cdf0>]
> (sys_getdents64+0x6c/0xc0)
>> [<c007cd84>] (sys_getdents64+0x0/0xc0) from [<c0023e60>]
> (ret_fast_syscall+0x0/0x2c)
>
> Please, post .config and "ls -lR /proc/sys" output _before_ suspend/resume.

Just to keep this on track.  It sounds like his suspend/resume backport was
incomplete and something there is smashing the list sysctl_head_next follows.

This would both cause files to disappear, and an oops.

Possibly it isn't an incomplete backport but instead a memory smash that hits
different places in different kernels.

Eric


