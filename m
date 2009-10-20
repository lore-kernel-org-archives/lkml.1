Return-Path: <linux-kernel-owner+w=401wt.eu-S1751893AbZJTM57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbZJTM57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 08:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZJTM56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 08:57:58 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42282 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751190AbZJTM56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 08:57:58 -0400
Date: Tue, 20 Oct 2009 07:56:49 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/apic: limit irq affinity
Message-ID: <20091020125649.GA25066@sgi.com>
References: <20090930160259.GA7822@sgi.com> <20091012193433.GB2691@elte.hu> <20091012193704.GA8708@sgi.com> <20091014071014.GK784@elte.hu> <20091014120225.GA9674@sgi.com> <20091014122653.GA15048@elte.hu> <20091015011339.GA17374@sgi.com> <4AD6B364.2050801@kernel.org> <20091015135039.GA24455@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015135039.GA24455@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 08:50:39AM -0500, Dimitri Sivanich wrote:
> On Wed, Oct 14, 2009 at 10:30:12PM -0700, Yinghai Lu wrote:
> > Dimitri Sivanich wrote:
> > > This patch allows for hard restrictions to irq affinity via a new cpumask and
> > > device node value in the irq_cfg structure.
> > > 
> > > The mask forces IRQ affinity to remain within the specified cpu domain.
> > > On some UV systems, this domain will be limited to the nodes accessible
> > > to the given node.  Currently other X86 systems will have all bits in
> > > the cpumask set, so non-UV systems will remain unaffected at this time.
> > > 
> > 
> > can you check if we can reuse target_cpus for this purpose?
> >
>  
> The 'target_cpus' mask is in struct 'apic'.  It is a platform level mask
> (only one mask per platform).
> 
> The 'allowed' mask that I am adding is a per irq level mask (one mask per irq).
> Each irq might be coming from a device attached to a different node, and each
> of those nodes might require its irqs to have a different mask.
>

Assuming that the real issue here is in adding any more cpumasks to irq_cfg, I've created another version of the patch that does not add the cpumask to irq_cfg.  The UV specific irq code will store these cpumasks (one per node).

Will send this shortly.
