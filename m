Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbZILA5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbZILA5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 20:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZILA5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 20:57:15 -0400
Received: from kroah.org ([198.145.64.141]:33973 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZILA5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 20:57:14 -0400
Date: Fri, 11 Sep 2009 17:54:46 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Linux SCSI Mailing List <linux-scsi@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Giridhar Malavali <giridhar.malavali@qlogic.com>,
       Ravi Anand <ravi.anand@qlogic.com>,
       Lalit Chandivade <lalit.chandivade@qlogic.com>
Subject: Re: [PATCHv2] qla2xxx: Correct compilation issues when
 CONFIG_MOUDLES=n.
Message-ID: <20090912005446.GA11691@kroah.com>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
 <20090907102747.ac6b98ff.randy.dunlap@oracle.com>
 <20090908182541.GB44157@plap4-2.local>
 <20090911175341.GH710@plap4-2.local>
 <1252708951.13282.151.camel@mulgrave.site>
 <20090912000742.GB12098@plap4-2.local>
 <20090912001752.GC12098@plap4-2.local>
 <20090912003808.GD12098@plap4-2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090912003808.GD12098@plap4-2.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 05:38:08PM -0700, Andrew Vasquez wrote:
> Randy Dunlap noted:
> 
>   when CONFIG_MODULES=n:
> 
> 	drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type
> 
>   in
> 
> 	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> 		KOBJ_CHANGE, envp);
> 
> Trigger kobject event on the 'struct device' hanging off the pci_dev.

Um, why?  What are you trying to do here?  kobject change should not be
for a device, or a "normal" kobject.

What do you expect userspace to do with this?  Where have you documented
it?

confused,

greg k-h
