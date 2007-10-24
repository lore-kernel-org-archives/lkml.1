Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbXJXPNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbXJXPNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbXJXPM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:12:59 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:57113 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbXJXPM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:12:58 -0400
Date: Wed, 24 Oct 2007 16:12:50 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [patch 1/2] rtc: release correct region in error path
Message-ID: <20071024151250.GA8684@linux-mips.org>
References: <20071023204843.442608289@ldl.fc.hp.com> <20071023205515.406778977@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023205515.406778977@ldl.fc.hp.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 02:48:44PM -0600, Bjorn Helgaas wrote:

> Subject: [patch 1/2] rtc: release correct region in error path
> 
> The misc_register() error path always released an I/O port region,
> even if the region was memory-mapped (only mips uses memory-mapped RTC,
> as far as I can see).

Well, MIPS just like other sane architectures has no concept of ioports.
So if there ever is something that's called an ioport on MIPS then it's
really a memory location in a memory address range where other PCish
devices are living, too.  So typically those memory addresses are
translated to an actual ioport access by a PCI bridge.  There are a few
systems where this concept just apply easily such as DECstations, so
there we simply claim the device such as the RTC in this case is memory
mapped.

Anway:

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
