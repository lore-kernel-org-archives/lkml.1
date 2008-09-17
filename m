Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbYIQKMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYIQKMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 06:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYIQKLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 06:11:53 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:44095 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbYIQKLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 06:11:52 -0400
X-BigFish: VPS-50(zz1432R98dR936eQ62a3L1805M936fQ9371Pzz10d3izz5a6ciz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K7C4B7-02-R3K-01
Date: Wed, 17 Sep 2008 12:11:29 +0200
From: Robert Richter <robert.richter@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] pci: using printk(KERN_PCI v3
Message-ID: <20080917101129.GC23138@erda.amd.com>
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <1221640067-24389-4-git-send-email-yhlu.kernel@gmail.com> <20080917083506.GA24035@elte.hu> <86802c440809170141s5c206ec9ub1ea077ed923ec20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86802c440809170141s5c206ec9ub1ea077ed923ec20@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Sep 2008 10:11:30.0759 (UTC) FILETIME=[C1434570:01C918AD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.09.08 01:41:03, Yinghai Lu wrote:
> On Wed, Sep 17, 2008 at 1:35 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >> -                     printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
> >> +                     printk(KERN_DEBUG KERN_PCI
> >> +                              "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
> >
> > i think we should aim to make the common usage of this facility as easy
> > and short as possible. That means that i think the right line is:
> >
> > +                       printk(KERN_PCI
> > +                                "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
> >
> > as that is the shortest form. KERN_PCI should imply whatever
> > common-sense default. It should still make sense to specify KERN_FOO
> > KERN_PCI, to override that default.
> 
> vprintk will add default before that like
> like print(KERN_INFO KERN_PCI ....)

What about a pci_dbg() macro similiar to dev_dbg()? Same could be used
for ACPI, acpi_dbg().

-Robert

> 
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

