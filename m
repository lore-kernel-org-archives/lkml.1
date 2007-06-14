Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbXFNRoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbXFNRoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbXFNRo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:44:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47744 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbXFNRo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:44:27 -0400
Message-ID: <46717E77.3050706@garzik.org>
Date: Thu, 14 Jun 2007 13:44:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: James Bottomley <James.Bottomley@SteelEye.com>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com, arjan@linux.intel.com
Subject: Re: [patch 2a/3] Expose Power Management Policy option to users
References: <20070611184146.448266229@intel.com>	<20070611114820.5290a903.kristen.c.accardi@intel.com>	<466DA9DD.8080004@garzik.org>	<20070612104631.44dab4a3.kristen.c.accardi@intel.com>	<1181748408.3421.7.camel@mulgrave.il.steeleye.com> <20070614093952.c8ebef17.kristen.c.accardi@intel.com>
In-Reply-To: <20070614093952.c8ebef17.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Ok - sorry for my ignorance about SCSI - but my sources (i.e. Arjan) tell 
> me that the problem is that Link in ATA land means something different than 
> Link in SCSI land, and that what I really need to do is leave this code under
> the Host class, but rename it to something that more accurately reflects
> what it means under SCSI.

James' analogy holds, and is even more true once SATA Port Multipliers 
are in the picture.  Then you have remote SATA phys.  And James has 
essentially stated a long term libata problem:  libata wants its own ATA 
transport class, and perhaps a cleaning-up and coalescing of the 
in-kernel SATA phy objects and processes.

The main difference is that SATA doesn't have to worry about target phys 
and initiator phys, largely just the initiator phy.  And phys in SATA 
don't have unique identifiers (WWNs).

I don't think we should delay ALPM in order to complete phy objects and 
an ATA transport class.  But OTOH a transport class may be the best 
place to put these new sysfs nodes.  But#2, that train of logic leads 
one down the road of implementing a minimal ATA transport class across 
all supported ATA devices, which is something that probably only James 
is an expert at (transport classes that is, not ATA).


> Should I rename the file to "segment_power_management_policy"?

No.

	Jeff



