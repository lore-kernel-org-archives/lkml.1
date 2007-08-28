Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbXH1S3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbXH1S3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXH1S3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:29:06 -0400
Received: from colo.lackof.org ([198.49.126.79]:49102 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbXH1S3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:29:05 -0400
Date: Tue, 28 Aug 2007 12:28:47 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>,
       Jesse Barnes <jesse.barnes@intel.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Fix boot-time hang on G31/G33 PC
Message-ID: <20070828182847.GC32342@colo.lackof.org>
References: <20070826015556.GC14130@parisc-linux.org> <20070828175908.GD19224@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828175908.GD19224@colo.lackof.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 11:59:08AM -0600, Grant Grundler wrote:
> On Sat, Aug 25, 2007 at 07:55:56PM -0600, Matthew Wilcox wrote:
> > 
> > This patch, loosely based on a patch from Robert Hancock, which was in
> > turn based on a patch from Jesse Barnes, fixes a boot-time hang on my
> > shiny new PC.  The 'conflict' mentioned in the patch in my case happens
> > to be between mmconfig and the graphics card, but it could easily be
> > between any pair of devices if they are left enabled by the BIOS and
> > mappen in the wrong place.
> 
> This issue has come up before:
>     http://www.uwsg.indiana.edu/hypermail/linux/kernel/0212.2/0232.html

Ok...finally found the thread I was looking for:
    http://www.ussg.iu.edu/hypermail/linux/kernel/0212.2/0978.html

or look at the "by Thread" page and search for "disable BAR":
    http://www.ussg.iu.edu/hypermail/linux/kernel/0212.2/index.html

Main difference now is not disabling anything on any sort of Bridge.

Summary: Sizing BARs has never been a very safe operation. We have to
mitigate as best we can and then live with the remaining risks.

cheers,
grant
