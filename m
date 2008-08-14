Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbYHNOC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbYHNOC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYHNOCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:02:49 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:5380 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYHNOCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:02:48 -0400
X-BigFish: VPS-29(z21eWz1432R1805Mzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K5LGC5-01-SZE-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 01/01][retry 3] x86: L3 cache index disable for 2.6.26
Date: Thu, 14 Aug 2008 09:02:34 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC6D@sausexmb4.amd.com>
In-Reply-To: <20080814134457.GD2262@elf.ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/01][retry 3] x86: L3 cache index disable for 2.6.26
Thread-Index: Acj+Fe5ZCi31G3kPQJCEjMmf2GI2JgAACfbA
References: <200807181603.52332.mark.langsdorf@amd.com> <200808131502.42611.mark.langsdorf@amd.com> <20080813234503.GA32154@kroah.com> <200808140843.44090.mark.langsdorf@amd.com> <20080814134457.GD2262@elf.ucw.cz>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Pavel Machek" <pavel@suse.cz>
CC: "Greg KH" <greg@kroah.com>, "Deguara, Joachim" <joachim.deguara@amd.com>,
       <gregkh@ucw.cz>, <tglx@linutronix.de>, <mingo@redhat.com>,
       <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Aug 2008 14:02:35.0580 (UTC) FILETIME=[674B8FC0:01C8FE16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +        ret = sscanf(buf, "%x", &val);
> > +        if (ret != 1)
> > +                return -EINVAL;
> 
> Is it okay to strlen() on user-supplied data? Do they have to be
> null-terminated? What about sscanf?

The strlen can go - it's no longer necessary.

If sscanf isn't safe in this context, there's a lot of code
in drivers/cpufreq/cpufreq.c that I cribbed from that needs
to be changed, too.
 
> > +        val |= 0xc0000000;
> > +        pci_write_config_dword(dev, 0x1BC + index * 4, val 
> & ~0x40000000);
> > +        wbinvd();
> > +        pci_write_config_dword(dev, 0x1BC + index * 4, val);
> 
> Should it do if capable() test before doing such stuff?

I don't think so.  If it got this far, it is an AMD processor
from family 0x10 or later, so it has wbinvd().

-Mark Langsdorf
Operating System Research Center
AMD

