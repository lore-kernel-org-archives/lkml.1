Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYGWBlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYGWBlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 21:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYGWBlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 21:41:39 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:49245 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752658AbYGWBli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 21:41:38 -0400
Date: Tue, 22 Jul 2008 21:41:37 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Message-ID: <20080723014137.GA12895@bromo.msbb.uc.edu>
References: <20080722233722.GA12247@bromo.msbb.uc.edu> <200807221723.04654.jbarnes@virtuousgeek.org> <20080723010058.GA12662@bromo.msbb.uc.edu> <200807221832.21167.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807221832.21167.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse,
   The file /sys/module/pcie_aspm/parameters/policy
shows...

[default] performance powersave 

Reading the original patch, I don't quite see how it would
show the aspm as disabled. I would think the current ASPM
fix patch should be modified to output a kernel message that
ASPM is being disabled because of pre-1.1 PCIe devices
when it does that (assuming it is disabling across the
board and not just for a specific device on the bus).
                         Jack

On Tue, Jul 22, 2008 at 06:32:20PM -0700, Jesse Barnes wrote:
> On Tuesday, July 22, 2008 6:00 pm Jack Howarth wrote:
> > Jesse,
> >     I found that patch right after I sent the email. Applying the ASPM
> > patch solves the boot hangs on under 2.6.26-git9 built with
> > CONFIG_PCIEASPM=y. I am attaching the dmesg log for such a boot
> > below. I am a little confused if the patch totally disables aspm on
> > my machine or just inhibits the hang. Is there a proc entry I can check
> > to monitor that aspm is in use?
> 
> It should disable ASPM on pre-1.1 PCIe devices, since apparently many of them 
> get ASPM wrong, resulting in bus hangs.  There's a file in sysfs to control 
> things:
> /sys/module/pcie_aspm/parameters/policy
> (see the description in 7d715a6c1ae5785d00fb9a876b5abdfc43abc44b for info).
> 
> With the patch applied hopefully it indicates that things are disabled.
> 
> Thanks for testing.
> 
> Jesse
