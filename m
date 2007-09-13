Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbXIMLQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbXIMLQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 07:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbXIMLQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 07:16:36 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:39844 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbXIMLQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 07:16:35 -0400
Date: Thu, 13 Sep 2007 15:16:37 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Greg KH <gregkh@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Shaohua Li <shaohua.li@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Message-ID: <20070913151637.A1679@jurassic.park.msu.ru>
References: <1189664467.17835.1.camel@sli10-conroe.sh.intel.com> <20070913073140.GA17367@parisc-linux.org> <1189668286.18361.3.camel@sli10-conroe.sh.intel.com> <20070913075536.GB17367@parisc-linux.org> <20070913095313.GA745@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <20070913095313.GA745@suse.de>; from gregkh@suse.de on Thu, Sep 13, 2007 at 02:53:13AM -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 02:53:13AM -0700, Greg KH wrote:
> On Thu, Sep 13, 2007 at 01:55:36AM -0600, Matthew Wilcox wrote:
> > Unfortunately if this patch does cause any machine to break, these will
> > be machines that worked fine up until this point, so that would be a
> > regression, which is worse.  Life sucks.
> 
> If, after a while, you think the change should go into the -stable tree,
> I have no objection.

I think it shouldn't - this change will almost certainly cause a regression.
There is a lot of system devices besides the host bridges that shouldn't be
disabled during BAR probe, like interrupt controllers, power management
controllers and so on.

We need a more sophisticated fix - I'm thinking of introducing "probe" field
in struct pci_dev which can be set by "early" quirk routines.

Ivan.
