Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbXFSO4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbXFSO4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbXFSO4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:56:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35604 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbXFSO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:56:12 -0400
Date: Tue, 19 Jun 2007 09:56:08 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux@highpoint-tech.com
Subject: bug in libata [was Re: [BUG] ide dma_timer_expiry, then hard lockup
Message-ID: <20070619145608.GA13904@austin.ibm.com>
References: <20070618175713.GD5836@austin.ibm.com> <20070618212704.394912b8@the-village.bc.nu> <20070618204601.GF5836@austin.ibm.com> <20070618220441.3a3af8ca@the-village.bc.nu> <20070618212238.GI5836@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618212238.GI5836@austin.ibm.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 04:22:38PM -0500, linas wrote:
> On Mon, Jun 18, 2007 at 10:04:41PM +0100, Alan Cox wrote:
> > please try using the libata
> > driver. 

Its worse. I get a hard hang (sysrq doesn't work) during boot, 
just when the system goes to read the partition table.

Recap: this is an older dual cpu intel box, with a vintage
HTP366 (and not a newer HPT370) on the system planar.  I'm
testing a configration that works fine with the old ide
drivers.

It looks like libata and scsi comes up. The disk is correctly
recognized; i.e. its brand, model number & size are correctly 
reported. printk shows that it hangs in msdos_partition, trying 
to read the partition table. The drive light is on full-solid,
again suggesting a possible irq storm.

Same behaviour for both 2.6.22-rc5-git1 and for 2.6.22-rc4-mm2

I seem to have trouble turning on scsi logging; it doesn't
seem to generate any output ... 

Any suggestions on how to proceed? 

--linas
