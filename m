Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbXKEX24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbXKEX24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbXKEX2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:28:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55287
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751938AbXKEX2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:28:48 -0500
Date: Mon, 05 Nov 2007 15:28:47 -0800 (PST)
Message-Id: <20071105.152847.95650043.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: gregkh@suse.de, jgarzik@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [GIT PATCH] PCI patches for 2.6.24-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.999.0711051438500.15101@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0711051414120.15101@woody.linux-foundation.org>
	<20071105222846.GA32090@suse.de>
	<alpine.LFD.0.999.0711051438500.15101@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Nov 2007 14:42:15 -0800 (PST)

> 
> 
> On Mon, 5 Nov 2007, Greg KH wrote:
> > 
> > I'm guessing that David is referring to a commit in his tree, not in
> > yours yet.
> 
> Well, I suspect that David referred to a commit that he just sent by 
> email. Which obviously will have a *different* commit ID once you commit 
> it - so it probably made sense in his tree, but not once he exported it 
> as an email instead of syncing with git natively. 
> 
> I also suspect that the whole series was re-ordered in email (or by you 
> reading/applying them in a different order). Since now the revert of the 
> "disable MSI" happens *before* the patch that looks like it will fix the 
> issue.
> 
> So I think David also probably didn't number his patches.

They were in the correct order, and I did number them.

The commit with the invalid commit ID in question went in a long time
ago, into 2.6.23 in fact, and as I explained in another email I
rebased by net-2.6 tree before I had sent that patch in, but I forgot
to update the commit log in these PCI layer changes.

I was not referencing a commit ID within the PCI patch set itself.

I just did a pull and verified that the commits are in the correct
order.

For reference the commit I meant to reference was:

commit 2fbe43f6f631dd7ce19fb1499d6164a5bdb34568
Author: Michael Chan <mchan@broadcom.com>
Date:   Thu Sep 6 12:04:29 2007 +0100

    [TG3]: Workaround MSI bug on 5714/5780.
    
    A hardware bug was revealed after a recent PCI MSI patch was made to
    always disable legacy INTX when enabling MSI.  The 5714/5780 chips
    will not generate MSI when INTX is disabled, causing MSI failure
    messages to be reported, and another patch was made to workaround the
    problem by disabling MSI on ServerWorks HT1000 bridge chips commonly
    found with the 5714.
    
    We workaround this chip bug by enabling INTX after we enable MSI and
    after we resume from suspend.
    
    Update version to 3.81.
    
    This problem was discovered by David Miller.
    
    Signed-off-by: Michael Chan <mchan@broadcom.com>
    Acked-by: Andy Gospodarek <andy@greyhouse.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>
