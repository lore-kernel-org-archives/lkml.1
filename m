Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbXDBQjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbXDBQjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 12:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbXDBQjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 12:39:23 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:45192 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933262AbXDBQjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 12:39:22 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Date: Mon, 2 Apr 2007 10:38:44 -0600
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Luck, Tony" <tony.luck@intel.com>, "Thomas Meyer" <thomas@m3y3r.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <lenb@kernel.org>
References: <617E1C2C70743745A92448908E030B2A0148323B@scsmsx411.amr.corp.intel.com> <m1r6rbz7mg.fsf@ebiederm.dsl.xmission.com> <200704020938.40482.bjorn.helgaas@hp.com>
In-Reply-To: <200704020938.40482.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704021038.44634.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 09:38, Bjorn Helgaas wrote:
> The main reason we wait until pci_enable_device() to allocate an
> IRQ number is that ia64 currently only has about 180 device vectors,
> and there are machines with more PCI slots than that.

Sigh, that didn't make much sense, did it?  At the time, ia64 didn't
support sharing IRQ vectors, and we preallocated four vectors for
every slot, including empty ones.  Allocate-on-demand dramatically
increased the number of devices we could support because most cards
use only one IRQ.
