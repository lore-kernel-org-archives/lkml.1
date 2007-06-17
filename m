Return-Path: <linux-kernel-owner+w=401wt.eu-S1761098AbXFQWtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098AbXFQWtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 18:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbXFQWt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 18:49:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbXFQWt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 18:49:26 -0400
Date: Sun, 17 Jun 2007 18:49:18 -0400
From: Dave Jones <davej@redhat.com>
To: Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070617224918.GC12483@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com
References: <1181721735.4418.10.camel@malory> <20070613162925.GG3875@redhat.com> <20070614011506.GA30566@alinoe.com> <20070617162235.GA5486@alinoe.com> <20070617190714.GA18115@redhat.com> <20070617195901.GA5689@alinoe.com> <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com> <20070617213355.GC3430@redhat.com> <20070617223649.GA31587@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617223649.GA31587@alinoe.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 12:36:49AM +0200, Carlo Wood wrote:
 > On Sun, Jun 17, 2007 at 05:33:55PM -0400, Dave Jones wrote:
 > > intel-agp
 > > 
 > > Though by the looks of things, with the working kernel, you don't have
 > > it loaded (it's dependant upon the 'agpgart' module, which prints the
 > > "Detected" line that was missing).
 > 
 > You are wrong.
 > I don't have any agpgart module at all, in any of the kernels that I compiled.

ok, then you must have CONFIG_AGP=y

 > $ find /lib/modules -name 'agpgart.ko'
 > $ /lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64 -name '*agp*.ko'
 > /lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64/kernel/drivers/char/agp/sis-agp.ko
 > /lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64/kernel/drivers/char/agp/intel-agp.ko
 > /lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64/kernel/drivers/char/agp/via-agp.ko
 > 
 > 2)
 > 
 > $ strings /lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64/kernel/drivers/char/agp/intel-agp.ko | grep 'agpgart: Detected an Intel'
 > <6>agpgart: Detected an Intel %s Chipset.
 > 
 > Hence, in the case that the kernel works, intel-agp is loaded
 > WITHOUT printing this Detected line

That doesn't make much sense.  The hardware doesn't change between
a working & not-working kernel, and somehow the PCI probing fails.
Hmm, do you have CONFIG_EDAC set ?
There's an outstanding bug (well, lack of feature) , where it claims
the PCI device before AGP gets a chance to.
This is unrelated to your hang however, but would at least explain
the inconsistent probing.

 > Perhaps my "solution" is to remove this module completely?
 > I don't seem to need it.

It's needed only for 3d, but it'd be good to figure out why its so
broken on your system, even if you don't need it.

	Dave

-- 
http://www.codemonkey.org.uk
