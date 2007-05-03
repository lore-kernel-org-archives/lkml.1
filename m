Return-Path: <linux-kernel-owner+w=401wt.eu-S1767422AbXECXIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767422AbXECXIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 19:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767451AbXECXIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 19:08:11 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:54665 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767422AbXECXIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 19:08:09 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200705032307.l43N7NOv032566@turbo.physics.adelaide.edu.au>
Subject: Re: [git pull] New firewire stack
To: stefanr@s5r6.in-berlin.de (Stefan Richter)
Date: Fri, 4 May 2007 08:37:23 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux1394-devel@lists.sourceforge.net, olh@suse.de,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, krh@redhat.com
In-Reply-To: <46399BDE.4040605@s5r6.in-berlin.de> from "Stefan Richter" at May 03, 2007 10:22:54 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Jonathan Woithe wrote:
> >> Olaf Hering wrote:
> >>> NACK.
> >>> Upgrade the current drivers/ieee1394/ with the new code, and keep all
> >>> existing module names.
> [...]
> > However, as a compromise how about renaming the existing stack's modules and
> > then reusing the existing names for the new stack?  Messy I know, but this
> > way both stacks would still be available without recompilation for those who
> > needed them and the sbp2-as-root dilemma raised by Olaf would also be
> > covered.
> 
> I.e. new modules:
> 	ieee1394 (was fw-core)
> 	ohci1394 (was fw-ohci)
>       :

> old modules, for example:
> 	ieee1394-old
> 	ohci1394-old
>       :
> 
> Looks... weird.
> 
> On the other hand, a 1394 module compilation cycle in order to do the
> fallback is not such a huge issue, except that it requires the person to
> be able to compile modules.  That's probably the main issue.

True on all counts.  I guess it's a question of whether the lack of an easy
fallback path will significantly reduce the number of testers.  I don't have
enough of a feel to answer that.

> 	eth1394  (to be done) --- but that's a bad name anyway, it
>                                   implements IP over 1394, not Ethernet

So, when eth1394 is ported the name should be something like fw-ip, at least
if we are to remain consistent with the other 3 module names.

> > Oh yes, it would be nice to have working PCILynx support again (although I
> > acknowledge it's unlikely to happen).  Some of us do have these cards
> > installed for sniffing purposes (using nosy) but it would be nice to be able
> > to use them with libraw1394 as well.  It would for example save me having to
> > swap cards depending on what I needed to do (I have insufficient PCI slots
> > to have both the PCILynx and OHCI cards installed simultaneously).
> 
> But then, what is the actual utility of pcilynx?  (I mean the current
> driver, not the card or a future driver.)  Last time I checked, sbp2 was
> broken without OHCI's physical DMA, and AFAIK raw1394's newer iso API
> and video1394 and dv1394 don't work with pcilynx either.

It certainly doesn't support the raw1394 API so its current usefulness is
extremely limited.

> Porting pcilynx to the new low-level API would be quite resource
> demanding --- seen in relation to which resources we have, what the
> existing pcilynx driver's state of affairs is, and how rare the hardware
> is.  (For those who have the hardware, the stand-alone Nosy is
> undoubtedly the killer application, not pcilynx.)

Precisely.  As I said, I've probably got a corner case and it's certainly
not worth the effort just for that.  It would be nice though.  You're right
about nosy; so long as nosy (which is independent of the firewire stack)
keeps working I'll be happy. :)

Regards
  jonathan
