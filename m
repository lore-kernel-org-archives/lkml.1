Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab0BPPpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 10:45:30 -0500
Received: from poutre.nerim.net ([62.4.16.124]:52166 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932918Ab0BPPp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 10:45:26 -0500
Date: Tue, 16 Feb 2010 16:45:23 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Denis Turischev <denis@compulab.co.il>,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
Message-ID: <20100216164523.5a3e13a5@hyperion.delvare>
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A2D58DB5@orsmsx508.amr.corp.intel.com>
References: <4B73DAEE.5080400@compulab.co.il>
	<4B73DB4B.40501@compulab.co.il>
	<20100216100809.GA2935@sortiz.org>
	<43F901BD926A4E43B106BF17856F0755A2D58DB5@orsmsx508.amr.corp.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 05:59:34 -0800, Pan, Jacob jun wrote:
> 
> >
> >On Thu, Feb 11, 2010 at 12:26:19PM +0200, Denis Turischev wrote:
> >> Intel Poulsbo (SCH) chipset LPC bridge controller contains several
> >> functions. Creating and MFD driver for the LPC bridge controller allows
> >> simultaneous use of SMBus and GPIO interfaces on the SCH.
> >That looks like an nice patch to me. Before merging it, I'd like to get
> >Jacob's view on it though. Jacob, does moving the SCH SMBus driver to a
> >platform one look fine to you ?
> >
> [[JPAN]] i agree with merging gpio and smbus into lpc driver. the only question
> i had was whether impact to the user space tools has been considered. iirc,
> there are sensors detect tools probe pci bus for smbus controllers, not sure it
> does that for platform bus.

That shouldn't be a problem. The PCI device is still present, so
sensors-detect will see it. Then it will load the required driver, and
that driver will instantiate i2c adapters. The script then probes all
i2c adapters regardless of who created them, so the exact driver
implementation doesn't matter.

-- 
Jean Delvare
