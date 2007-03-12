Return-Path: <linux-kernel-owner+w=401wt.eu-S964989AbXCLEeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbXCLEeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 00:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965060AbXCLEeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 00:34:44 -0400
Received: from mxl144v79.mxlogic.net ([208.65.144.79]:42076 "EHLO
	p02c11o146.mxlogic.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S964989AbXCLEen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 00:34:43 -0400
Date: Mon, 12 Mar 2007 06:35:09 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
Message-ID: <20070312043509.GC19601@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <20070311183709.GB19601@mellanox.co.il> <m1mz2jv9ue.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1mz2jv9ue.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 12 Mar 2007 04:37:25.0611 (UTC) FILETIME=[22292BB0:01C76460]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15044.001
X-TM-AS-Result: No--15.310800-4.000000-31
X-Spam: [F=0.2347753992; S=0.234(2007030701)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Eric W. Biederman <ebiederm@xmission.com>:
> Subject: Re: SATA resume slowness, e1000 MSI warning
> 
> "Michael S. Tsirkin" <mst@mellanox.co.il> writes:
> 
> > OK I guess. I gather we assume writing read-only registers has no side effects?
> > Are there rumors circulating wrt to these?
> 
> I haven't heard anything about that, and if we are writing the same value back
> it should be pretty safe.
> 
> I have heard it asserted that at least one version of the pci spec
> only required 32bit accesses to be supported by the hardware.  One of
> these days I will have to look that and see if it is true.

Maybe. But surely before the PCI-X days.

> I do know
> it can be weird for hardware developers to support multiple kinds of
> decode.

Is this the only place where Linux uses pci_read_config_word/pci_read_config_dword?
I think such hardware will be pretty much DOA on all OS-es.  Why don't we wait
and see whether someone reports a broken config?

> As I recall for pci and pci-x at the hardware level the only
> difference in between 32bit transactions and smaller ones is the state
> of the byte-enable lines.

True, and same holds for PCI-Express.

So let's assume hardware implements RO correctly but ignores the BE bits -
nothing bad happens then, right?

-- 
MST
