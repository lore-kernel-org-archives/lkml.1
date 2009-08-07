Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZHGQON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZHGQON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZHGQOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:14:12 -0400
Received: from automation-pros.com ([72.243.156.18]:44925 "EHLO
	smtp.automation-pros.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753804AbZHGQOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:14:12 -0400
X-Greylist: delayed 1335 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 12:14:11 EDT
Message-ID: <4A7C4C8C.1050006@turmel.org>
Date: Fri, 07 Aug 2009 11:47:24 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: David Dillow <dave@thedillows.org>, Andi Kleen <andi@firstfloor.org>,
       Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
References: <20090805171513.GA10443@kroah.com> <20090805192037.19c54c4d@lxorguk.ukuu.org.uk> <20090805182805.GA7534@kroah.com> <20090805185136.GA21442@kroah.com> <87ljlxhrnr.fsf@basil.nowhere.org> <1249575658.19886.8.camel@lap75545.ornl.gov> <20090806183147.GA28409@suse.de>
In-Reply-To: <20090806183147.GA28409@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Aug 06, 2009 at 12:20:58PM -0400, David Dillow wrote:
>> On Thu, 2009-08-06 at 17:46 +0200, Andi Kleen wrote:
>>> Greg KH <greg@kroah.com> writes:
>>>> It makes the userspace boot process much simpler and easier to maintain,
>>>> as well as providing a way to handle rescue disks and images trivially,
>>>> and it makes the kernel _less_ dependant on the early userspace bootup
>>>> scripts.
>>> As a initrd less kernel user I can really only agree: getting rid
>>> of the udev-in-initrd requirement would be a big step forward
>>> in usability. Typically I always have to pre populate 
>>> a on disk /dev manually first to get my kernels to boot.
>> If you use mount by label or UUID, you still need udev (or other tools)
>> in the initrd to find the right disk, correct?
> 
> Yes, you would.
> 

Might be straying off-topic here, but I find software raid to be 
particularly useful in this case.  I've been using it on my home server 
for a few years now, including through the transition from ide to 
libata.  The kernel autostart for md devices has been rock-solid, and 
successfully hides the real device name.  No initramfs required.

You might want to adapt the md+lvm setup from the gentoo docs [1], even 
if you only have one disk (degraded mirror).  The only gotcha I've 
encountered was forgetting to set up grub after replacing a failed disk, 
and it happened to be first in line in the BIOS.  Didn't notice 'till an 
extended power outage forced a reboot.

Phil

[1] http://www.gentoo.org/doc/en/gentoo-x86+raid+lvm2-quickinstall.xml
