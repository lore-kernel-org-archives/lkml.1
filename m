Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbXLLXLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbXLLXLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 18:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXLLXLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 18:11:32 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37517 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbXLLXLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 18:11:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v2] x86 boot : export boot_params via sysfs
References: <1197449991.14443.88.camel@caritas-dev.intel.com>
	<20071212174613.GC16049@kroah.com> <47602044.9010104@zytor.com>
	<20071212185935.GA5941@kroah.com> <47603109.6080909@zytor.com>
	<20071212222146.GC16474@kroah.com>
	<20071212144351.3fd0c6ec.randy.dunlap@oracle.com>
Date: Wed, 12 Dec 2007 16:08:43 -0700
In-Reply-To: <20071212144351.3fd0c6ec.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Wed, 12 Dec 2007 14:43:51 -0800")
Message-ID: <m17ijjtssk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:

> I don't know if this patch is trying to solve this (->) problem, but there
> is a desire for drivers to have a decent way to tell if the kernel that
> is executing is a kexec/crash kernel or not.  If it is a kexec/crash
> kernel, then (some) drivers may not allocate as many buffers as they
> normally do, since the kernel would likely be configured to use
> less memory.  The solution doesn't have to involve sysfs .. or it could.

The patch is trying to make it easier to observe new fields passed to
the kernel by the bootloader in user space.

The drivers should have a way to look at the amount of memory the
kernel is configured to use and operate on that.  I expect this is a
general embedded scenario.

I don't think I have seen a driver concern in the kdump environment
that is unique to that environment.  So in general I figure we should
use whatever it is that is different about the kdump environment that
the causes the drivers to want to do something differently, so the
changes can ideally support more people.

Eric
