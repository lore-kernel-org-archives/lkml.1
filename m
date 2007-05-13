Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbXEMSEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbXEMSEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbXEMSE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:04:26 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:21070 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbXEMSEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:04:25 -0400
Message-ID: <46475324.7050303@msgid.tls.msk.ru>
Date: Sun, 13 May 2007 22:04:20 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Dan Aloni <da-x@monatomic.org>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow kernel module exclusion on load
References: <20070513132517.GA14038@localdomain> <20070513092352.18cd80de@freepuppy> <20070513171555.GA27920@localdomain>
In-Reply-To: <20070513171555.GA27920@localdomain>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Aloni wrote:
> On Sun, May 13, 2007 at 09:23:52AM -0700, Stephen Hemminger wrote:
>> On Sun, 13 May 2007 16:25:17 +0300
>> Dan Aloni <da-x@monatomic.org> wrote:
>>
>>> Kernel developers might find it useful for quickly getting out from some 
>>> rough debugging scenarios.
>>>
>>> Signed-off-by: Dan Aloni <da-x@monatomic.org>
>>>
>> There is already the modprobe blacklist ability in user space.
> 
> Yes, however the point here is that you can easily (and temporarily)
> blacklist a module *manually* from the boot loader without needing to 
> actually perform a complete and successful boot. Using modprobe's 
> blacklist requires editing /etc files, and it also doesn't apply 
> for initrd/initramfs or other system/distribution-specific scripts 
> that would do hardcoded sequential insmod invocations (for example
> on embedded systems that require minimal userspace complexity).

There are two issues (IMHO anyway), both are userspace.

First is the ability blacklist the given module from bootloader.
My initramfs has it since the beginning - it allows a noload=xxx
paramerer (comma-separated list of module patterns, cumulative),
for exactly this purpose.  I implemented modprobe in shell (not
using a binary from module-init-tools) for initramfs (it's some
20 lines of shell code).  Because of exactly that reason - on
certain systems i had a problem with certain drivers, resulting
in boot failures.  Later on, this set of modules gets transformed
into a modprobe blacklist list.  It's trivial to do.

And second is what to do with direct insmod invocations in minimal
embedded system startup sequence.  Well, minimal it or not, but
shell is present anyhow, so I don't see any problem with that,
either...

Just my $0.02...

/mjt
