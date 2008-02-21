Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYBUGF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYBUGF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 01:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYBUGFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 01:05:49 -0500
Received: from crca.org.au ([67.207.131.56]:51423 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbYBUGFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 01:05:47 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <47BD14AC.5070002@nigel.suspend2.net>
Date: Thu, 21 Feb 2008 17:05:32 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201241.30952.jesse.barnes@intel.com> <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org> <200802201344.11643.jesse.barnes@intel.com> <47BCAD6E.9080704@nigel.suspend2.net> <20080221001357.GA29796@srcf.ucam.org> <47BCC866.9000102@nigel.suspend2.net> <20080221004632.GA25869@suse.de> <47BCD112.3010708@nigel.suspend2.net> <20080221044331.GB21499@suse.de>
In-Reply-To: <20080221044331.GB21499@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg.

Greg KH wrote:
> On Thu, Feb 21, 2008 at 12:17:06PM +1100, Nigel Cunningham wrote:
>> Hi.
>>
>> Greg KH wrote:
>>> On Thu, Feb 21, 2008 at 11:40:06AM +1100, Nigel Cunningham wrote:
>>>> Hi.
>>>>
>>>> Matthew Garrett wrote:
>>>>> On Thu, Feb 21, 2008 at 09:45:02AM +1100, Nigel Cunningham wrote:
>>>>>> - people keep talking about hibernating to an ext3 fs mounted on fuse 
>>>>>> as a limitation of the freezer. To do that with kexec, you're still 
>>>>>> going to have to bmap the ext3 fs and pass the block list (in which 
>>>>>> case we can also do it without kexec) or umount all the ext3/fuse part 
>>>>>> and remount in the kexec'd kernel. Sort of defeats the purpose, doesn't 
>>>>>> it?
>>>>> No, with a freezer-based model you can basically *never* suspend to 
>>>>> anything related to FUSE or a userspace USB device or anything involving 
>>>>> userspace iSCSI initiators or whatever. Sure, there are cases where 
>>>>> moving away from the current model doesn't buy you anything, but that 
>>>>> doesn't mean that the current model is a good thing. It's not. The 
>>>>> freezer is a fundamentally broken concept.
>>>> Putting drivers and filesystems in userspace is the fundamentally broken 
>>>> concept. Not just when it comes to the freezer. The whole idea is 
>>>> inherently racy.
>>> Racy with regards to other things becides trying to suspend a machine?
>>> If so, what?
>> That depends on what sort of tangled web you want to weave.
> 
> Lots of them :)
> 
> We have tanks running Linux using userspace USB drivers for vision
> control systems (scary, I know...)  They seem to be successfully running
> for many years now, and I'm interested in making sure those kinds of
> things keep working.
> 
> We also have laser welding robots with userspace PCI drivers in car
> manufacturing plants.  And other laser cutting robots slicing wood in
> patterns moving at a rate of over 3 meters a second.  Again, with
> userspace drivers and Linux.
> 
> Those users would also love to know of any potential problems you know
> of for this situation.
> 
>> Low memory situations is one other situation that occurs to me
>> quickly, especially (though not only) if your ability to swap were to
>> depend upon a userspace driver and/or filesystem.
> 
> Sure, swap over a userspace filesystem or driver isn't a sane idea.  And
> neither is swaping over NFS over a PPP connection attached to a USB to
> serial device.  Yes, it's possible, and all in the kernel, but not a
> wise decision.
> 
> Other than foolish configurations, if you come up with other issues
> surrounding userspace drivers that could cause problems, please let me
> know.

A simple OOM condition isn't an issue? Surely a driver stalling because 
some of its memory gets swapped out just before it goes to use it would 
be a problem if it resulted in getting the length of a cut wrong or 
caused some distorted vision or a late turn :>

Am I missing something? Maybe these drivers mlock memory to avoid those 
issues or something like that?

Regards,

Nigel
