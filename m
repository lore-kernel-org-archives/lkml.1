Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbXI0CKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbXI0CKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 22:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbXI0CKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 22:10:23 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55100 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbXI0CKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 22:10:22 -0400
Date: Wed, 26 Sep 2007 19:04:47 -0700
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com
Subject: Re: [PATCH] Add iSCSI iBFT support.
Message-ID: <20070927020447.GA26131@kroah.com>
References: <20070926184652.GA16369@andromeda.dapyr.net> <20070926211057.GA3050@kroah.com> <200709262008.50023.konrad@darnok.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709262008.50023.konrad@darnok.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 08:08:45PM -0400, Konrad Rzeszutek wrote:
> On Wednesday 26 September 2007 17:10:57 Greg KH wrote:
> > On Wed, Sep 26, 2007 at 02:46:52PM -0400, Konrad Rzeszutek wrote:
> > > This patch adds a /sysfs/firmware/ibft/table binary blob which exports
> > > the iSCSI Boot Firmware Table (iBFT) structure.
> >
> > Please don't do that.  Binary files are for things that are
> > "pass-through" only, not anything that the kernel knows the structure
> > of, or cares about (like PCI config space, or firmware blobs for
> > devices.)
> >
> > Just export the individual fields of this table as individual files
> > please.
> 
> My goal was to do that in the next version of this patch. My first step was
> to get the fundamental work reviewed (and hopefully accepted) and then build 
> on top of that.
> 
> The exploiter of this binary file (/sys/firmware/ibft/table) is the 
> iscsi-initiator-utils package and it has a library that parses the binary 
> blob data. The thought was to get this first working (ie, 
> iscsi-initiator-utils finds /sys/firmware/ibft/table, parses it and work) and 
> then work to have the iscsi-initiator-support individual sysfs entries.
> 
> Or do you think I should skip the fundamental step and work on the next
> version of this patch that exports the data as individual data and post that
> one instead?

Just do the individual files, do not export binary structures through
sysfs as that is not allowed.

The individual files should be much easier to export than the binary
blog anyway :)

thanks,

greg k-h
