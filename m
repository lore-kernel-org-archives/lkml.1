Return-Path: <linux-kernel-owner+w=401wt.eu-S936335AbXHHQqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936335AbXHHQqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbXHHQqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:46:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39913 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457AbXHHQqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:46:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, "Mao, Bibo" <bibo.mao@intel.com>
Subject: Re: [PATCH 0/5] x86_64 EFI support -v3
References: <1185851569.23149.25.camel@caritas-dev.intel.com>
	<m1myxdtc19.fsf@ebiederm.dsl.xmission.com>
	<1186378838.3769.27.camel@caritas-dev.intel.com>
Date: Wed, 08 Aug 2007 10:45:53 -0600
In-Reply-To: <1186378838.3769.27.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Mon, 06 Aug 2007 13:40:38 +0800")
Message-ID: <m1d4xyc6v2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> On Tue, 2007-07-31 at 12:47 +0800, Eric W. Biederman wrote:
>> Using efi_set_virtual means kdump doesn't work which means that no
>> one is going to use this in a prebuilt kernel.
>
> It is possible to make kexec/kdump work with EFI virtual mode, in
> following ways:

Yes we can make it work if we absolutely have to.  There doesn't
seem to be much point to jump through hoops for a feature
we don't need.  A fixed virtual address and a fixed physical
address have essentially the same implications for the kernel.
A fixed address we are stuck with and if the kernel diverge
by very much we have problems.

Since there are people actively investigating things like booting
OpenBSD via kexec things get even worse. Nothing hardly runs
on ia64 so that issue doesn't come up.

As for not using EFI at all.  If we can avoid it/not use it in the
dump kernel there is very little point in having it in the primary
kernel.

Especially since it appears EFI is only 64 bit or only 32 bit I
think we need to forget about efi_set_virtual_address and only
call into EFI via a trampoline that set things up properly
whatever mode EFI is running in on that particular box.

So far there don't seem to be any compelling advantages to running
EFI in virtual address mode and several compelling disadvantages
included having to change the permissions on the kernels memory
map to running EFI in virtual mode.

Please let's stick to a physical mode trampoline and only revisit
the topic when users start having problems because of the performance
hit of going through our trampoline to the EFI runtime services.

Eric
