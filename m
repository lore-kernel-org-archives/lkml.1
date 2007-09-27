Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbXI0AdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbXI0AdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 20:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXI0AdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 20:33:09 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:53734 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbXI0AdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 20:33:08 -0400
From: Konrad Rzeszutek <konrad@darnok.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Add iSCSI iBFT support.
Date: Wed, 26 Sep 2007 20:08:45 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com
References: <20070926184652.GA16369@andromeda.dapyr.net> <20070926211057.GA3050@kroah.com>
In-Reply-To: <20070926211057.GA3050@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709262008.50023.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 September 2007 17:10:57 Greg KH wrote:
> On Wed, Sep 26, 2007 at 02:46:52PM -0400, Konrad Rzeszutek wrote:
> > This patch adds a /sysfs/firmware/ibft/table binary blob which exports
> > the iSCSI Boot Firmware Table (iBFT) structure.
>
> Please don't do that.  Binary files are for things that are
> "pass-through" only, not anything that the kernel knows the structure
> of, or cares about (like PCI config space, or firmware blobs for
> devices.)
>
> Just export the individual fields of this table as individual files
> please.

My goal was to do that in the next version of this patch. My first step was
to get the fundamental work reviewed (and hopefully accepted) and then build 
on top of that.

The exploiter of this binary file (/sys/firmware/ibft/table) is the 
iscsi-initiator-utils package and it has a library that parses the binary 
blob data. The thought was to get this first working (ie, 
iscsi-initiator-utils finds /sys/firmware/ibft/table, parses it and work) and 
then work to have the iscsi-initiator-support individual sysfs entries.

Or do you think I should skip the fundamental step and work on the next
version of this patch that exports the data as individual data and post that
one instead?

>
> thanks,
>
> greg k-h


