Return-Path: <linux-kernel-owner+w=401wt.eu-S1750733AbXBVMu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750733AbXBVMu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 07:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXBVMu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 07:50:26 -0500
Received: from [81.2.110.250] ([81.2.110.250]:48462 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750733AbXBVMuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 07:50:24 -0500
Date: Thu, 22 Feb 2007 13:53:06 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Francesco Pretto" <ceztko@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Message-ID: <20070222135306.4eb757c2@lxorguk.ukuu.org.uk>
In-Reply-To: <e5ab0f710702211701u4c5b62c5jb560f166641512ff@mail.gmail.com>
References: <e5ab0f710702211415p37444279td690c2db4b4ca8ab@mail.gmail.com>
	<20070221235541.35f3d0da@lxorguk.ukuu.org.uk>
	<e5ab0f710702211701u4c5b62c5jb560f166641512ff@mail.gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> However, i'm not still sure i enabled as much debugging info as i
> could in the kernel configuration. If you need more, please point me
> to precise configuration options.

You grabbed a lot of junk but you did grab this line

[17179682.560000] Synchronizing SCSI cache for disk sda: 

Which means sd_sync_cache got called and flushed the data to disk.

I don't think you can do the other needed debugging without a recompile.

The following will generate a vast amount of debug of which only the end
matters. You may well want to build a kernel this way, boot it with
init=/bin/sh and then at the shell prompt do "halt -f" so you don't get
too much debug

In include/linux/libata.h change

#undef ATA_DEBUG                /* debugging output */
#undef ATA_VERBOSE_DEBUG        /* yet more debugging output */

so both of the undef-s read define

#define ATA_DEBUG
#define ATA_VERBOSE_DEBUG

and recompile


