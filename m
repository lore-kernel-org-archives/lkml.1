Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbXEIJqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbXEIJqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbXEIJqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:46:00 -0400
Received: from canuck.infradead.org ([209.217.80.40]:54681 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbXEIJp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:45:59 -0400
Date: Wed, 9 May 2007 02:46:47 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, bunk@stusta.de, cornelia.huck@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
	(PCI_MULTITHREAD_PROBE)
Message-ID: <20070509094647.GB13245@kroah.com>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com> <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org> <20070508.141554.112287211.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508.141554.112287211.davem@davemloft.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 02:15:54PM -0700, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 8 May 2007 08:27:34 -0700 (PDT)
> 
> > Threading at the bus level just inevitably means things like random 
> > numbers for devices depending on some timing/scheduling issue. That's 
> > nasty.
> 
> I hadn't considered this issue, so ignore the other reply I made to
> this thread.  Although as an aside I'm starting to become of an
> opinion that device numbering doesn't matter.  Every device should
> have a unique ID of sorts, or a unique physical location, and that
> should factor into the thing users use to refer to the object.

We pretty much already do this today.

For block devices, as an example, look at /dev/disk/ which udev creates
so that you can handle block devices being discovered in any order
possible.

> Anyways, it would be nice, however, to really deal with the case like
> when the IDE layer is waiting for a probe to port X to timeout,
> meanwhile we could be initializing the networking card.
> 
> Another bad case is, as you mentioned, SCSI bus resets and SAS/FC
> fabric scans.  Those take several seconds if not longer and it's
> really stupid to not be able to do other things during that time.

Yes, because of that, I think this kind of multi-probe stuff should be
done in the IDE/SATA/SCSI bus code, not in the PCI code, as PCI
"normally" does not have any speed issues.

thanks,

greg k-h
