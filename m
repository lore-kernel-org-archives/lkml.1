Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbXI0Eb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbXI0Eb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 00:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbXI0EbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 00:31:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15167 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbXI0EbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 00:31:18 -0400
Date: Wed, 26 Sep 2007 21:29:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com
Subject: Re: [PATCH] Add iSCSI iBFT support.
Message-Id: <20070926212921.33e2e58d.randy.dunlap@oracle.com>
In-Reply-To: <200709262052.44845.konrad@darnok.org>
References: <20070926184652.GA16369@andromeda.dapyr.net>
	<20070926142950.46bbfcd2.randy.dunlap@oracle.com>
	<200709262052.44845.konrad@darnok.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 20:52:43 -0400 Konrad Rzeszutek wrote:

> > > +config ISCSI_IBFT
> > > +	tristate "iSCSI Boot Firmware Table Attributes"
> > > +	depends on X86
> >
> > why only on X86?
> 
> PowerPC exports this data via the OpenFirmware so it already shows in 
> the /sysfs entries. I was thinking to combine those sysfs entries under this 
> code, but that is something in the future.
> 
> In regards to all other platforms, I figured I would only make it supported 
> under platforms that have been tested. Is there anything that stops this from 
> working for example of IA64? Well no. The hardware that supports the iBFT is 
> either in the BIOS or in NICs - so the SGI or HP boxes _should_ work, however 
> I am not comfortable to make it supported unless I've tested it.

That's not how Linux development works.  You (we) have a huge
test lab around the world.  You practice "release early, release
often" and get testing/feedback on it.  Maybe even patches.  :)


> > Need blank line here... except why is this function in the header
> 
> Fixed blank line.
> > file?  and why is it inline?
> 
> Q: "Why is this function in the header file"
> If the find_ibft() was to be implemented in firmware/iscsi_ibft.c code the 
> firmware-driver couldn't be compiled as a module (or rather it could, but 
> when the vmlinuz was to be linked it would complain about missing symbol - 
> find_ibft). I was thinking to let the user give the choice whether they want 
> to load this firmware driver or have it built-in the kernel.
> 
> Q:"Why is it inline"
> Uhh. It does not need to. I will remove the 'inline' part. 

But we strongly prefer not to have non-inline C code in header files,
[and the function does not need to be inline]
so find_ibft() needs a home in some source file/code that won't be built
as a loadable module, right?  And preferably not duplicated (i386 &
x86_64 versions; but we should see a merged x86/ arch soon, so it
sounds).  Would ia64 have its own version of find_ibft() or use this
same code?

I think that for now you can put find_ibft() in both setup.c files
and the merged x86/ arch tree can eliminate one of them.

On looking back at the patch, why aren't the ibft_phys and find_ibft()
parts of both setup.c patches surrounded by #ifdef CONFIG_ISCSI_IBFT &
#endif ?


---
~Randy
Phaedrus says that Quality is about caring.
