Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbXLLTBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbXLLTBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXLLTBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:01:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36723 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbXLLTBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:01:32 -0500
Date: Wed, 12 Dec 2007 10:59:35 -0800
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v2] x86 boot : export boot_params via sysfs
Message-ID: <20071212185935.GA5941@kroah.com>
References: <1197449991.14443.88.camel@caritas-dev.intel.com> <20071212174613.GC16049@kroah.com> <47602044.9010104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47602044.9010104@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 09:54:12AM -0800, H. Peter Anvin wrote:
> Greg KH wrote:
>> On Wed, Dec 12, 2007 at 04:59:51PM +0800, Huang, Ying wrote:
>>> This patch export the boot parameters via sysfs. This can be used for
>>> debugging and kexec.
>>>
>>> The files added are as follow:
>>>
>>> /sys/kernel/boot_params/data	: binary file for struct boot_params
>>> /sys/kernel/boot_params/version	: boot protocol version
>>>
>>> This patch is based on 2.6.24-rc4-mm1 and has been tested on i386 and
>>> x86_64 platoform.
>>>
>>> This patch is based on the Peter Anvin's proposal.
>> As outlined in a previous email, I object to the whole structure being
>> exported to userspace as a binary blob.  Please change that.
>
> I would prefer to have the binary blob available; exported fields is 
> possible too, of course.
>
> This is a binary structure defined by protocol;

What protocol?  Is this a "standard" documented somewhere?

> in that way it's not significantly different from something passed
> from the firmware (in fact, it might very well *be* passed from the
> firmware.)  We have in the past found platform bugs by looking at the
> contents of the whole structure, e.g.  to find that part of it has
> been inappropriately clobbered.

For debugging things, then just export it through debugfs.

> It is also in the form needed by e.g. kexec to operate.

Does kexec need this today to work properly?  Or is this something new?

What userspace program is going to know the exact data format of this
blob, and where is it going to know that format from?  The kernel header
files in sanitized form?  Or something else?

thanks,

greg k-h
