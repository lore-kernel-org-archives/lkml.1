Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbXK0Fea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbXK0Fea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbXK0FeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:34:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41662 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbXK0FeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:34:22 -0500
Date: Mon, 26 Nov 2007 21:28:47 -0800
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: Doug Maxey <dwm@enoyolf.org>, linux-kernel@vger.kernel.org,
       pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com,
       randy.dunlap@oracle.com, hpa@zytor.com, lenb@kernel.org,
       mike.anderson@us.ibm.com, dwm@austin.ibm.com
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Message-ID: <20071127052847.GA777@kroah.com>
References: <20071126225642.GA7973@andromeda.dapyr.net> <20071127033138.GB30770@kroah.com> <11870.1196136773@bebe.enoyolf.org> <200711262350.13100.konrad@darnok.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711262350.13100.konrad@darnok.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 11:50:10PM -0500, Konrad Rzeszutek wrote:
> > >
> > > sysfs files have ONE VALUE PER FILE, not a whole bunch of different
> > > things in a single file.  Please fix this.
> >
> > The subparameters _are_ actually part of a single value, that value being
> > associated with the initiator instance.
> >
> > Konrad is trying to implement a "work-alike" for what open firmware does.
> > open-iscsi already has the ability to extract the same format
> > bits from real OFW.
> >
> > See open-iscsi.git/utils/fwparam_ppc.
> 
> 
> Greg,
> 
> In light of what Doug says (which is all true), should I go ahead with a new 
> version of this module which would export one value per file? The problem 
> that will be encountered is that a ethernetX sysfs directory would have (for 
> example):
> 
> /sys/firmware/ibft/ethernet0/pci-bdf
> 5:1:0
> /sys/firmware/ibft/ethernet0/mac
> 00:11:25:9d:8b:00
> /sys/firmware/ibft/ethernet0/vlan
> 0
> /sys/firmware/ibft/ethernet0/gateway
> 192.168.79.254
> /sys/firmware/ibft/ethernet0/origin
> 0
> /sys/firmware/ibft/ethernet0/subnet-mask
> 22
> /sys/firmware/ibft/ethernet0/ip-addr
> 192.168.77.41
> /sys/firmware/ibft/ethernet0/flags
> 7

Yes, that is the proper way to do this kind of thing in sysfs.

> And the flag would contain the value "7" which would mean the user would have 
> to parse what each bit means? (the v0.3 of the module does not export this 
> flag but uses it to figure out which is the boot iSCSI target).

Sure, as long as it means something to userspace, and is a single value,
and is documented, that's fine.

thanks,

greg k-h
