Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbYLSQ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbYLSQ5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYLSQ5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:57:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43640 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbYLSQ5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:57:12 -0500
Cc: initramfs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <9C4F1B7D-CCBC-48D7-8624-9A7C314C1590@redhat.com>
From: Jeremy Katz <katzj@redhat.com>
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20081219152708.GE9871@mit.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: Dracut -- Cross distribution initramfs infrastructure
Date: Fri, 19 Dec 2008 11:56:47 -0500
References: <1229540094.28858.150.camel@aglarond.local> <20081217190700.GA15377@infradead.org> <4949FD67.6040906@suse.de> <494B5031.5080306@bfh.ch> <20081219091841.207bc951@kopernikus.site> <494BA7CE.2020007@suse.de> <20081219152708.GE9871@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 19, 2008, at 10:27 AM, Theodore Tso wrote:
> On Fri, Dec 19, 2008 at 02:55:26PM +0100, Hannes Reinecke wrote:
>>
>> The goal of the initrd is to activate and mount the root fs.
>> And the root fs _only_. Every other system should be configured
>> once the main system is running.
>
> Don't forget resuming from hibernation....

I haven't, although I haven't sat down to implement it yet.

> And of course, activating and mounting the root filesystem can be
> quite complicated --- it can involve loading driver modules,
> activiating md and/or lvm, prompting for a password, setting up
> networking (dhcp, routing, dns) for iSCSI and/or NFS/AFS/Lustre/et.al,
> the equivalent setup for Fiber Channel attached disks, etc.  If
> there's any cryptography involved, the user may need to be prompted
> for a password and/or key and/or fingerprint scan to unlock TPM unit
> to access the key, etc.

Well, driver modules should be being loaded by udev.  Period.  If  
something requires a manual modprobe, that's a bug IMHO.  The other  
stuff, while non-trivial, is surprisingly doable from udev rules.

> There may also be times when it is useful to operate on the root
> filesystem in some way before it is mounted; in most cases the
> operation can bedone on a filesystem mounted read-only, yes --- but at
> the cost of needing to reboot afterwards if the root filesystem needs
> to be modified by said userspace tool.

I think that once you start getting into this realm, though, you end  
up with an incredibly over-complicated and slow initramfs.  If we  
instead focus on keeping things "fast", the reboot afterwards isn't  
that costly.

> Finally, note that part the discussion at the Kernel Summit, and also
> what David Jones was looking to work at, was to do something that
> could included as part of the kernel sources.  The idea is that as
> responsibility for early boot is moved from the kernel, an mkinitramfs
> which is fixed and distributed by the distribution might not work with
> a newer kernel.org kernel.  So the idea that was explored was adding a
> common mkinitramfs with basic functionality into kernel sources, with
> the ability for distributions to add various "value add" enhancements
> if they like.  This way if the kernel wants to move more functionality
> (for example, in the area of resuming from hibernation) out of the
> kernel into initramfs, it can do so without breaking the ability of
> older distributions from being able to use kernel.org kernels.
>
> So IMHO, it's important not only that the distributions standardize on
> a single initramfs framework, but that framework get integrated into
> the kernel sources.

Yeah, Dave and I have talked a fair bit about that.  It's just  
significantly easier to get something going _outside_ of the kernel  
sources and then work towards integrating it.  The plus side of  
integrating it is that the existing bits to generate a built-in  
initramfs can go away.

Jeremy
