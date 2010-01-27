Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392Ab0A0Wp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab0A0Wp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254Ab0A0WpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:45:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40239 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756210Ab0A0WpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:45:24 -0500
Date: Wed, 27 Jan 2010 22:46:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.33-rc5
Message-ID: <20100127224654.76db3693@lxorguk.ukuu.org.uk>
In-Reply-To: <1264631609.3075.94.camel@mulgrave.site>
References: <1264614691.3075.19.camel@mulgrave.site>
	<20100127222404.6dfdd0a7@lxorguk.ukuu.org.uk>
	<1264631609.3075.94.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 16:33:29 -0600
James Bottomley <James.Bottomley@suse.de> wrote:

> On Wed, 2010-01-27 at 22:24 +0000, Alan Cox wrote:
> > > Penchala Narasimha Reddy Chilakala, ERS-HCLTech (1):
> > >       aacraid: fix File System going into read-only mode
> > 
> > If aacraid is actually getting patches then see
> > also http://bugzilla.kernel.org/show_bug.cgi?id=11120 which I found
> > bugzilla tidyying.
> > 
> > Contains a patch and test confirmations
> 
> So the patch it contains is almost certainly wrong in general; Mark was
> just suggesting it as a trial ... it might work for specific adapter
> versions but reducing the queue depth by half globally will impact
> performance noticeably.  The bug report does rather sound like cabling
> issues are leading to a firmware related problem.

Odd then that they worked reliably until the numbers were increased.
Sorry but having worked on the aacraid for a long time in the past I
don't buy that explanation. Cabling issues would get logged by the driver
and the controller. Secondly I don't buy it because the reporter was
Matthias Ulrichs, who to borrow a hitchhikers term "really knows where his
towel is". 

The patch isn't a halving the queue size - its a returning to the known
working state from a regression (unfixed).

The story is pretty simple

Worked until the kernel changed
Didn't work with kernel change
Worked after the kernel changed back.

Kernel's dont go in and fix your cables (much as I wish they did) and
there are two folks who've actually found the bug report specifically
confirming it.

When you have a cable fault on the aacraid you can get hangs on crappier
firmware sets (normally in the BIOS boot though) but it's not dependant
on queue size - it either works or it doesn't. On good firmware you get
nice logged errors and it recovers if possible (or multipaths if you've
got the right bits).

Alan
