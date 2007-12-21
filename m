Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbXLUUHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbXLUUHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 15:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbXLUUGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 15:06:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36893 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbXLUUGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 15:06:53 -0500
Date: Fri, 21 Dec 2007 12:05:29 -0800
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: Doug Maxey <dwm@enoyolf.org>, darnok@68k.org, linux-kernel@vger.kernel.org,
       pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com,
       randy.dunlap@oracle.com, hpa@zytor.com, lenb@kernel.org,
       mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Add iSCSI IBFT support (v0.4.2)
Message-ID: <20071221200529.GA22989@kroah.com>
References: <20071128233422.GD6736@andromeda.dapyr.net> <20071205004418.GH6736@andromeda.dapyr.net> <22081.1196824331@bebe.enoyolf.org> <20071205194708.GB1801@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205194708.GB1801@andromeda.dapyr.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 03:47:08PM -0400, Konrad Rzeszutek wrote:
> On Tue, Dec 04, 2007 at 09:12:11PM -0600, Doug Maxey wrote:
> > Overall, looks nice.  Good work.
> 
> Thank you.
> 
> > 
> > comments inline below...
> > 
> > On Tue, 04 Dec 2007 20:44:19 -0400, darnok@68k.org wrote:
> > > On Wed, Nov 28, 2007 at 07:34:22PM -0400, Konrad Rzeszutek wrote:
> > > >
> > > > This patch adds /sysfs/firmware/ibft/[initiator|targetX|ethernetX]
> > > > directories along with text properties which export the the iSCSI Boot
> > > > Firmware Table (iBFT) structure.
> > > >
> > > > What is iSCSI Boot Firmware Table? It is a mechanism for the iSCSI
> > > > tools to extract from the machine NICs the iSCSI connection information
> > > > so that they can automagically mount the iSCSI share/target. Currently
> > > > the iSCSI information is hard-coded in the initrd.
> > > >
> > > > For full details of the IBFT structure please take a look at:
> > > > ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_iscsi_boot_firmware_table_v1.02.pdf
> > >
> > > Here is an updated version which provides an attribute symlink (in the
> > > ethernetX directory) called 'device' to the NIC device, instead of
> > > exporting a 'pci_bdf' file which had the "bus:slot:func" values.
> > >
> > > Review would be much appreciated.
> 
> This next version (0.4.2) includes: much better error unrolling
> when kobject registration fails, fixes from Doug's review, and uses the
> 'kset_create_and_add' API that Greg KH posted. It has been tested on
> todays 2.6.24-rc4-gkh tree.

Looks much nicer, good job.

However I changed the kobject api again, so some minor changes will need
to happen (kobject_init() and kobject_add() parameters have changed),
and you don't need to call kobject_del() right before kobject_put().
Hm, that last one was always true, so that wasn't needed before...

Do you want me to add this to my driver/ tree and fix up the kobject
issues there so it all builds properly, and it gets sent to Linus for
2.6.25?

thanks,

greg k-h
