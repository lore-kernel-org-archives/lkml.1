Return-Path: <linux-kernel-owner+w=401wt.eu-S1767290AbXECA3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767290AbXECA3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 20:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767289AbXECA3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 20:29:46 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:57160 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767290AbXECA3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 20:29:45 -0400
X-Greylist: delayed 1432 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2007 20:29:44 EDT
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200705030004.l4304l8h012587@turbo.physics.adelaide.edu.au>
Subject: Re: [git pull] New firewire stack
To: linux1394-devel@lists.sourceforge.net
Date: Thu, 3 May 2007 09:34:47 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe), olh@suse.de,
       akpm@linux-foundation.org, stefanr@s5r6.in-berlin.de,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       krh@redhat.com
In-Reply-To: <mailman.197656.1178135675.32383.linux1394-devel@lists.sourceforge.net> from "linux1394-devel-request@lists.sourceforge.net" at May 02, 2007 12:54:35 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kritian wrote:
> Olaf Hering wrote:
> > On Tue, May 01, Kristian H?gsberg wrote:
> > 
> >>   drivers/firewire/Kconfig          |   60 ++
> > 
> > NACK.
> > Upgrade the current drivers/ieee1394/ with the new code, and keep all
> > existing module names.
> 
> What's your reasoning here?  Having different module names allows people to 
> compile both stacks and switch between them as they wish.

While I'm not fussed about the implementation details I agree with those
who have advocated a migration period where both stacks are present.  A
major change such as this is almost certain to turn up bugs when it becomes
more widely tested, and many firewire users are unlikely to test the
new stack without an easy fallback to a known working system.  Yes, I know
development and production systems should be separate, but I (and many
others) can't afford enough hardware for that.

> Another point in favour of different module names is that the new stack
> doesn't actually provide the same user space interfaces as the old stack. 
> Basically, no applications use the raw kernel interfaces and the new stack
> is only compatible at the library level.  In the light of this, I think
> it's fair to change the module names.

Sounds reasonable to me.

However, as a compromise how about renaming the existing stack's modules and
then reusing the existing names for the new stack?  Messy I know, but this
way both stacks would still be available without recompilation for those who
needed them and the sbp2-as-root dilemma raised by Olaf would also be
covered.

> As for putting the new stack in drivers/ieee1394 - I don't know, I think it 
> makes sense to keep the new stack in it's own directory.

My immediate thought it that it would be neater and clearer to have both
stacks in different directories, but I could live with either.

Oh yes, it would be nice to have working PCILynx support again (although I
acknowledge it's unlikely to happen).  Some of us do have these cards
installed for sniffing purposes (using nosy) but it would be nice to be able
to use them with libraw1394 as well.  It would for example save me having to
swap cards depending on what I needed to do (I have insufficient PCI slots
to have both the PCILynx and OHCI cards installed simultaneously).

Regards
  jonathan
