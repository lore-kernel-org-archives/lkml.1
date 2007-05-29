Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbXE2NTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbXE2NTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbXE2NTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:19:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54660 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbXE2NTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:19:08 -0400
Date: Tue, 29 May 2007 15:19:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
Message-ID: <20070529131903.GA5024@one.firstfloor.org>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de> <20070529115324.GB18437@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529115324.GB18437@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 01:53:24PM +0200, Heiko Carstens wrote:
> On Tue, May 29, 2007 at 04:23:45AM +0200, Andi Kleen wrote:
> > Possible further checks that might make sense:
> > - panic() anywhere in drivers/* 
> 
> A driver should be allowed to panic. E.g. if it detects that due to a
> firmware or driver bug memory corruption happened. IMHO the best thing
> to do then is panic.

That is not how Linux normally operates. A BUG() doesn't panic() by
default either.

And on systems with IOMMU that is exactly the wrong thing to do.

Besides the problem is that bad drivers tend to badly abuse it
(e.g. see some particular BSD derviced SCSI drivers). We definitely
don't want any more of such code.

-Andi
