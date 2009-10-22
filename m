Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbZJVShq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbZJVShq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 14:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbZJVShp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 14:37:45 -0400
Received: from poutre.nerim.net ([62.4.16.124]:64453 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476AbZJVSho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:44 -0400
Date: Thu, 22 Oct 2009 20:37:46 +0200
From: Jean Delvare <khali@linux-fr.org>
To: djwong@us.ibm.com
Cc: Crane Cai <crane.cai@amd.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       lenb@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] i2c-scmi: Quirk to work on IBM machines with broken 
 BIOSes
Message-ID: <20091022203746.575d3928@hyperion.delvare>
In-Reply-To: <20091022174304.GO26149@tux1.beaverton.ibm.com>
References: <20091020231149.GM26149@tux1.beaverton.ibm.com>
	<20091021023016.GC32413@crane-desktop>
	<200910210857.13978.bjorn.helgaas@hp.com>
	<20091021173733.GN26149@tux1.beaverton.ibm.com>
	<20091022071748.GA17917@crane-desktop>
	<20091022174304.GO26149@tux1.beaverton.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 10:43:04 -0700, Darrick J. Wong wrote:
> On Thu, Oct 22, 2009 at 03:17:53PM +0800, Crane Cai wrote:
> 
> > This patch below represents my meanings:
> > *) add a new HID for IBM SMBus CMI devices
> > *) add methods for IBM SMBus CMI devices as you did
> > *) hook different HID with different control methods set
> > It may be more smooth for i2c-scmi, please consider.
> 
> Looks fine to me.
> 
> I still need the changes to drivers/acpi/scan.c, but if you push this patch
> upstream then I'll reroll my patch as a follow-on to yours...
> 
> >  static const struct acpi_device_id acpi_smbus_cmi_ids[] = {
> > -	{"SMBUS01", 0},
> > +	{"SMBUS01", (kernel_ulong_t)&smbus_methods},
> > +	{"SMBUSIBM", (kernel_ulong_t)&ibm_smbus_methods},
> 
> ...with the custom HID string #define'd in a header file someplace.
> 
> Actually, if you'll add a Signed-off-by line to your patch, I'll submit both of
> them as a patchset and save you a little work. :)

As soon as there is an agreement on how the problem would better be
addressed, I'll be happy to pick the patches.

> > +	for (; id->id[0]; id++)
> 
> Stylistic nit--would it be clearer to initialize id in the for loop instead of
> at the beginning of the function?

Definitely, yes.

-- 
Jean Delvare
