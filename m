Return-Path: <linux-kernel-owner+w=401wt.eu-S932804AbYBUAk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbYBUAk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758763AbYBUAkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:40:19 -0500
Received: from crca.org.au ([67.207.131.56]:48766 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104AbYBUAkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:40:17 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <47BCC866.9000102@nigel.suspend2.net>
Date: Thu, 21 Feb 2008 11:40:06 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jesse Barnes <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201241.30952.jesse.barnes@intel.com> <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org> <200802201344.11643.jesse.barnes@intel.com> <47BCAD6E.9080704@nigel.suspend2.net> <20080221001357.GA29796@srcf.ucam.org>
In-Reply-To: <20080221001357.GA29796@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Matthew Garrett wrote:
> On Thu, Feb 21, 2008 at 09:45:02AM +1100, Nigel Cunningham wrote:
> 
>> - people keep talking about hibernating to an ext3 fs mounted on fuse as 
>> a limitation of the freezer. To do that with kexec, you're still going 
>> to have to bmap the ext3 fs and pass the block list (in which case we 
>> can also do it without kexec) or umount all the ext3/fuse part and 
>> remount in the kexec'd kernel. Sort of defeats the purpose, doesn't it?
> 
> No, with a freezer-based model you can basically *never* suspend to 
> anything related to FUSE or a userspace USB device or anything involving 
> userspace iSCSI initiators or whatever. Sure, there are cases where 
> moving away from the current model doesn't buy you anything, but that 
> doesn't mean that the current model is a good thing. It's not. The 
> freezer is a fundamentally broken concept.

Putting drivers and filesystems in userspace is the fundamentally broken 
concept. Not just when it comes to the freezer. The whole idea is 
inherently racy. You can draw silly diagrams about how the freezer 
supposedly works in LCA slides and spread FUD as much as you like. In 
the end, though, it's not nearly as hit-and-miss as you say, and 
replacing the freezer with a kexec based freezer is only going to create 
as many problems as it removes.

>> I also wonder about how much of a pain it's going to be setting up 
>> userspace for this kexec'd kernel. Will you need a separate partition 
>> just for it? If not, will the userspace be loaded into memory all the 
>> time (more memory wasted for normal use), or loaded from ordinary 
>> partitions at kexec time (how to do safely? - more info to transfer 
>> between kernels?).
> 
> You're looking at a tiny amount of memory when compared to current 
> systems. It's really not a problem.

Please, quantify 'tiny'. In embedded, 5MB can be too much. I've worked 
on embedded solutions. I'm not pulling problems out of thin air.

Regards,

Nigel


