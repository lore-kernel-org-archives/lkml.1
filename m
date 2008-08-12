Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYHLWCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYHLWCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbYHLWB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:01:57 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:64531 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbYHLWBy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:01:54 -0400
X-BigFish: VPS-27(z21eWz1432R1805Mzzzzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0K5ID6N-01-AAG-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 01/01][retry 1] x86: L3 cache index disable for 2.6.26
Date: Tue, 12 Aug 2008 17:01:46 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC68@sausexmb4.amd.com>
In-Reply-To: <20080812215659.GA12911@elf.ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/01][retry 1] x86: L3 cache index disable for 2.6.26
Thread-Index: Acj8xjEhGe65Y8vjSwSiP/AGqs0zrwAAHtmQ
References: <200807181603.52332.mark.langsdorf@amd.com> <20080808220011.GA12156@ucw.cz> <200808121104.09288.mark.langsdorf@amd.com> <20080812215659.GA12911@elf.ucw.cz>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Pavel Machek" <pavel@suse.cz>, "Greg KH" <greg@kroah.com>
CC: "Deguara, Joachim" <joachim.deguara@amd.com>, <gregkh@ucw.cz>,
       <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Aug 2008 22:01:47.0215 (UTC) FILETIME=[03C765F0:01C8FCC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Okay, this is a simpler version that includes most of Ingo's
> > clean-ups and style changes.  It only displays the two
> > cache index values.  Is this acceptable?
> 
> Not sure, lets ask greg. And it probably should have few lines
> in Documentation going with it, so we know new interface is added and
> how it looks.

Okay, I'll add that and resubmit tomorrow.
 
> > +static ssize_t show_cache_disable(struct _cpuid4_info 
> *this_leaf, char *buf)
> > +{
> > +        int node = 
> cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
> > +        struct pci_dev *dev = get_k8_northbridge(node);
> > +        ssize_t ret = 0;
> > +        int i;
> > +
> > +        if (!this_leaf->can_disable) 
> > +                return sprintf(buf, "-1");
> 
> This should return -ERRNO, right?

Right, thanks.
 
> > +        for (i = 0; i < 2; i++) {
> > +                unsigned int reg = 0;
> > +
> > +                pci_read_config_dword(dev, 0x1BC + i * 4, &reg);
> > +
> > +                ret += sprintf(buf, "%s %x\t", buf, reg);
> > +        }
> > +	ret += sprintf(buf,"%s\n", buf);
> 
> So you print "buf" few times? Why? And you use both \t and \n 
> as deliminer...

I'm printing the values of the two config registers into
the string buffer, separated by tabs, and terminated by
an EOL.  Is there a prefered way to do that instead of
what I have?

-Mark Langsdorf
Operating System Research Center
AMD

