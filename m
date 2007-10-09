Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbXJIF7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbXJIF7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 01:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXJIF7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 01:59:34 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34188 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbXJIF7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 01:59:33 -0400
Date: Tue, 9 Oct 2007 08:01:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Oleg Verych <olecom@flower.upol.cz>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-ID: <20071009060104.GA22087@uranus.ravnborg.org>
References: <20071008200255.GA16497@uranus.ravnborg.org> <20071008205048.GY22435@flower.upol.cz> <20071009041743.GA21552@uranus.ravnborg.org> <20071008215316.6e186b89.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008215316.6e186b89.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 2) We need to share much more Kconfig* between the individual architectures
> >    First step is to let all arch's use drivers/Kconfig
> 
> 2) isn't terribly difficult, just takes some time and willingness
> of $arch maintainers to some changes, but please explain a bit more
> why it is needed...?

A prerequisite for moving ARCH selection to Kconfig is that we
read in all Kconfig files for all architectures.
To do so efficient we should avoind including the same Kconfig
file for each architecture which is obviously the case today.

The efficiency comes both with respect to reading the files but
also memory consumption. If we read in drivers/Kconfig only once
then we will avoid some duplication compared to reading drivers/Kconfig
once for each architecture.

The structure we should aim for is something like a top-level
Kconfig file that pull in relevant parts from the kernel tree
and where the arch Kconfig only pull in additional Kconfig files
from that arch.

When we get this far we will have a more logical structure
in the Kconfig file and their distribution.

But the showstopper is the part with choice value that cannot have more
than a single prompt so when we have the same choice value
used in two arch Kconfig files then kconfig will warn and the
choice will do the wrong thing.
I never took a deeper look at this - I seem to get distracted each
time I try to understand all the inner details of the kconfig
use of data structures.

	Sam

