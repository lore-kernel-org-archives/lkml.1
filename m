Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbZCXR54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbZCXR54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbZCXRy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:54:57 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:12401 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759458AbZCXRyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:54:53 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Mar 2009 13:54:52 EDT
Date: Tue, 24 Mar 2009 12:45:14 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: "Karl O. Pinc" <kop@meme.com>
Cc: netdev@vger.kernel.org, linux-hotplug@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Network Device Naming mechanism and policy
Message-ID: <20090324174514.GA22700@auslistsprd01.us.dell.com>
References: <20090324154617.GA16332@auslistsprd01.us.dell.com> <1237912977l.501l.10l@mofo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237912977l.501l.10l@mofo>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:42:57AM -0500, Karl O. Pinc wrote:
> My thoughts on the subject; from someone who is not
> particularly qualified to have opinions.
> 
> Reading over your post, I searched for a single sentence describing
> the problem you're trying to solve.  What I came up with was
> this:
> 
> On 03/24/2009 10:46:17 AM, Matt Domsch wrote:
> 
> > Users continue to have to figure out, for each system type
> >and
> >potentially for each boot, which NIC is connected to which name.  This
> >has been the #1 customer complaint about Linux on Dell servers for
> >several years.  I'd prefer not to keep it this way.

yeah, that's pretty much it.

> Perhaps a little magic in the udev rule that creates the
> z70_persistent-net-rules file would solve the basic problem.
> It could sort the nics by mac address when creating the
> names.  It need only run when the z70 file does not exist.
> I presume this would produce consistent results in most cases
> and it feels technically feasible; although I am not
> fully qualified to make that judgment.
> 
> Rather that put the onus on udev to make the above
> change Dell could just run a little program at first
> boot that mungs the z70 file as desired.  (It could then
> force a reboot; I forget if this would be needed.)
> I imagine Dell boots the boxes once at the factory,

nearly all dell systems running linux in the world were not
factory-installed with that os.  this isn't something i can simply
patch in our factories.  it needs to be fixed as far upstream as
possible.

> but if not then the user has to suffer with a longer
> boot process at first boot.  because this is driven
> by dell, dell would know exactly what nic has what
> name.  and dell knows what nics are on the mobo and
> what are not, and so can control the mac address sort
> order as desired.

well, there is no "mac address sort" anywhere.  (nor is that really a
good algorithm to use).


> The other solution that screams out at me is to ditch
> those legacy BIOSes and go to something like LinuxBIOS.
> Again, I'm not really qualified, but it sure feels like
> there's an answer in this approach.

It's not a BIOS problem.  BIOS can inform the OS of what it thinks
about hardware location, names, etc.  And our PowerEdge (9G and newer)
servers do - using SMBIOS 2.6 standard features we added (types 9, 10,
and 41) to the specification - exactly to allow such.  Now something
needs to use that information.  That something today is biosdevname,
which could be more cleanly integrated with udev.

> The other point that struck me was that sometimes, it seems,
> users want persistence in the naming of their network devices
> and sometimes they want device names based on bus position.

indeed
 
> The sucky thing is that symlinks and nics don't mix well
> and so it seems impossible to satisfy both the above
> requirements at the same time.  This is an area that
> IMHO could be better addressed by the Linux community.

correct.

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
