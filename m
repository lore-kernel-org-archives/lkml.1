Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbXE2QtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbXE2QtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbXE2QtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:49:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:41064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbXE2QtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:49:08 -0400
Date: Tue, 29 May 2007 08:57:32 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       us15@os.inf.tu-dresden.de, davej@redhat.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reduce AER init error information
Message-ID: <20070529155732.GA7068@suse.de>
References: <1177832284.14017.270.camel@ymzhang> <465C3446.5020603@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465C3446.5020603@googlemail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 04:10:14PM +0200, Michal Piotrowski wrote:
> Hi all,
> 
> Zhang, Yanmin napisa??(a):
> > PCI-Express AER support in kernel requires BIOS to provide _OSC support
> > to allow the AER Root port service driver to request for native control
> > of AER. If a root port supports AER capablity, but BIOS doesn't provide
> > _OSC for it, aerdriver will print many debug information to system console.
> > Below is a log example.
> > 
> > *******************Error information example************
> > Evaluate _OSC Set fails. Status = 0x0005
> > Evaluate _OSC Set fails. Status = 0x0005
> > aer_init: AER service init fails - Run ACPI _OSC fails
> > aer: probe of 0000:00:02.0:pcie01 failed with error 2
> > Evaluate _OSC Set fails. Status = 0x0005
> > Evaluate _OSC Set fails. Status = 0x0005
> > aer_init: AER service init fails - Run ACPI _OSC fails
> > aer: probe of 0000:00:04.0:pcie01 failed with error 2
> > Evaluate _OSC Set fails. Status = 0x0005
> > Evaluate _OSC Set fails. Status = 0x0005
> > aer_init: AER service init fails - Run ACPI _OSC fails
> > aer: probe of 0000:00:06.0:pcie01 failed with error 2
> > ******************End of Error information example******
> > 
> > 
> > As _OSC is an optional capability of BIOS, such error information looks
> > like overly-verbosed. The patch against kernel 2.6.21 changes it to just
> > print one line report messages if aerdriver fails to attach the root port
> > service device.
> > 
> > Below is an example of new output.
> > AER service couldn't init device 0000:00:02.0:pcie01 - no _OSC support
> > 
> > 
> > Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
> > 
> > ---
> > 
> [..]
> 
> This patch fixes a 2.6.21 regression. Please add this to the -stable and mainline queue.

Care to forward the above patch to the stable@kernel.org address after
it goes into Linus's tree?

thanks,

greg k-h
