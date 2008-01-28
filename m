Return-Path: <linux-kernel-owner+w=401wt.eu-S1761373AbYA1QOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761373AbYA1QOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYA1QOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:14:46 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1634 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752624AbYA1QOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:14:45 -0500
Date: Mon, 28 Jan 2008 16:11:48 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Arai <arai@vmware.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ACPI CPU hot removal: Problem with automatic scripting in response to hotplug events
Message-ID: <20080128161148.GB4032@ucw.cz>
References: <4790EC2D.4050201@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4790EC2D.4050201@vmware.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-01-18 10:13:01, Daniel Arai wrote:
> I have an x86_64 system that's capable of doing ACPI CPU 
> hot removal.
> One issue that's worrying me right now is that there 
> isn't enough
> information to automatically script CPU removal when 
> it's requested by
> the hardware platform.
> 
> I'm doing my testing with 2.6.24-rc8 from kernel.org.  I 
> have applied
> the patch series from 
> http://bugzilla.kernel.org/show_bug.cgi?id=2884
> to avoid running into deadlocks on CPU removal.  This 
> issue is almost
> certainly independent of these patches.
> 
> /sbin/hotplug does get invoked for CPU ejection requests 
> that are sent
> from the platform.  It only gets a pointer to the ACPI 
> /sys node
> describing the ACPI processor object for which ejection 
> has been
> requested.  There doesn't seem to be a way to map from 
> this device
> node to a CPU number so the processor can be taken 
> offline before

Submit a patch, I guess you are first one with physical hotplug
capable system.

> 3. Provide a symbolic link from the ACPI device tree to 
> the
> appropriate CPU device, and possibly the reverse link as 
> well.  This
> would enable /sbin/hotplug to find the appropriate CPU 
> node to take
> the CPU offline by itself, and would also be usefil for 
> a system
> administrator who needs to know the mapping from ACPI 
> device to CPU
> number.  What I don't know is how hard it is to 
> construct these new
> nodes.  It also gets slightly messy because ACPI 
> processor objects can
> appear at different levels in the /sys node hierarchy 
> depending on how
> they're represented in the ACPI tables, so constructing 
> relative
> symlinks isn't a trivial matter.
> 
> I think that overall the third approach seems the most 
> appealing,
> because it provides additional information to the system 
> administrator
> without adding special information just there for 
> /sbin/hotplug.  I
> think #1 is probably a nice thing to have just in 
> general, though I
> don't understand the rationale for the code being the 
> way it is now.
> Sadly, #2 is the only one I'm sure I know how to 
> implement.

So do #2 and see what happens...

> So any suggestions on the best way to go about solving 
> this problem?
> 
> I've also noticed one other minor anomaly.  CPUs get 
> device nodes
> named ACPI0007:00, ACPI0007:01, ACPI0007:02, etc.  If I 
> remove a CPU
> from the system, then add another cpu to the system, the 
> removed
> device node goes away, but its number doesn't get 
> reused.  So if I
> remove and then re-add the same CPU over and over, I end 
> up getting
> nodes named ACPI0007:03, then that gets deleted, then I 
> get
> ACPI0007:04, and so on.  Is this supposed to happen?  
> What happens if
> I remove and add the same CPU more than 99 times?

No idea, I'm surprised it works at all...
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
