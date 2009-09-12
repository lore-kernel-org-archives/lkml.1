Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbZILOaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbZILOaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 10:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbZILOaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 10:30:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbZILOaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 10:30:14 -0400
Subject: Re: [PATCHv2] qla2xxx: Correct compilation issues when
 CONFIG_MOUDLES=n.
From: James Bottomley <James.Bottomley@suse.de>
To: Greg KH <greg@kroah.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Linux SCSI Mailing List <linux-scsi@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Giridhar Malavali <giridhar.malavali@qlogic.com>,
       Ravi Anand <ravi.anand@qlogic.com>,
       Lalit Chandivade <lalit.chandivade@qlogic.com>
In-Reply-To: <20090912043333.GA12349@kroah.com>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
	 <20090907102747.ac6b98ff.randy.dunlap@oracle.com>
	 <20090908182541.GB44157@plap4-2.local> <20090911175341.GH710@plap4-2.local>
	 <1252708951.13282.151.camel@mulgrave.site>
	 <20090912000742.GB12098@plap4-2.local>
	 <20090912001752.GC12098@plap4-2.local>
	 <20090912003808.GD12098@plap4-2.local> <20090912005446.GA11691@kroah.com>
	 <20090912025623.GA14824@plap4-2.local>  <20090912043333.GA12349@kroah.com>
Content-Type: text/plain
Date: Sat, 12 Sep 2009 09:30:07 -0500
Message-Id: <1252765807.4238.74.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 21:33 -0700, Greg KH wrote:
> On Fri, Sep 11, 2009 at 07:56:23PM -0700, Andrew Vasquez wrote:
> > On Fri, 11 Sep 2009, Greg KH wrote:
> > 
> > > On Fri, Sep 11, 2009 at 05:38:08PM -0700, Andrew Vasquez wrote:
> > > > Randy Dunlap noted:
> > > > 
> > > >   when CONFIG_MODULES=n:
> > > > 
> > > > 	drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type
> > > > 
> > > >   in
> > > > 
> > > > 	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> > > > 		KOBJ_CHANGE, envp);
> > > > 
> > > > Trigger kobject event on the 'struct device' hanging off the pci_dev.
> > > 
> > > Um, why?  What are you trying to do here?  kobject change should not be
> > > for a device, or a "normal" kobject.
> > > 
> > > What do you expect userspace to do with this?  Where have you documented
> > > it?
> > 
> > The purpose was described here:
> > 
> > 	http://article.gmane.org/gmane.linux.scsi/54155
> > 
> > Basically we'd like to instruct user-space to retrieve a blob of data
> > automatically.
> 
> Hm, like a firmware object perhaps?
> 
> > Original implementation used the kboject hanging off
> > the module which does not exist when CONFIG_MODULES=n.  It was
> > suggested that perhaps an alternative would be to use 'struct device'
> > kobj.  Any tips on how to trigger such a driver-specific event,
> > perhaps a dedicated kobject exported by the driver itself???
> 
> Why not use the firmware interface for it, that is what it is designed
> for, and you will not have to craft any new udev rules.

The data is going the wrong way to use the current firmware interface,
which is designed to load data from userspace into the kernel.  For this
interface, we want the data to go the other way (i.e. the kernel has a
blob of dump data it would like userspace to save if it can).

I'd be amenable to updating the firmware interface to do this, but it
looks like adding a completely new codepath, which it's not clear even
belongs there.

James


