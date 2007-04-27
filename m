Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbXD0O5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbXD0O5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbXD0O5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:57:09 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55170 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952AbXD0O5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:57:07 -0400
X-Originating-Ip: 74.109.98.66
Date: Fri, 27 Apr 2007 10:55:54 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: James Bottomley <James.Bottomley@SteelEye.com>
cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yokota Hiroshi <yokota@netlab.cs.tsukuba.ac.jp>,
       GOTO Masanori <gotom@sanori.org>
Subject: Re: [2.6 patch] drivers/scsi/nsp32.c: remove kernel 2.4 code
In-Reply-To: <1177633855.5532.8.camel@mulgrave.il.steeleye.com>
Message-ID: <Pine.LNX.4.64.0704271051240.22643@localhost.localdomain>
References: <20070426234742.GH3468@stusta.de> 
 <Pine.LNX.4.64.0704261955450.14047@localhost.localdomain> 
 <20070427001324.GP3468@stusta.de> <1177633855.5532.8.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, James Bottomley wrote:

> Personally, I don't like to see 2.4 and 2.6 in a new driver, and
> will tend to try to force it to be 2.6 only.  For an existing
> driver, I tend to be much more tolerant: removing the huge gobs of
> code to achieve 2.6 only is usually a bit disruptive on both the
> driver and the maintainer
>
> > But if a driver is no longer actually maintained for both kernels
> > these checks become useless (and there quickly arised
> > unconditional 2.6-only code in such a driver) and can be removed.
>
> This driver is maintained by
>
> Yokota Hiroshi <yokota@netlab.cs.tsukuba.ac.jp>
> GOTO Masanori <gotom@sanori.org>
>
> As it says in the header.  It was last modified in May 2006, so it
> is maintained under the somewhat elastic standards of SCSI.  I've
> cc'd them to see what they think.

while we're on the subject, what's the policy on supporting kernel
version selection *within* the 2.5 series?  as in:

$ grep -r "KERNEL_VERSION(2,5" *
drivers/scsi/pcmcia/nsp_cs.h:#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,74))
drivers/scsi/pcmcia/nsp_cs.c:#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
drivers/scsi/pcmcia/nsp_cs.c:#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,2))
drivers/scsi/pcmcia/nsp_cs.c:#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
... etc etc ...

granted, this doesn't happen in a lot of files (almost of them
SCSI-related), but is it official policy to support code based on its
release number in the 2.5 series of releases?  unless you have a good
reason, wouldn't it make more sense to compare against (2,6,0) rather
than, say, (2,5,73)?  just an observation.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
