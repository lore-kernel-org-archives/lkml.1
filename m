Return-Path: <linux-kernel-owner+w=401wt.eu-S1761092AbXFRAQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761092AbXFRAQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbXFRAQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:16:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbXFRAQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:16:36 -0400
Date: Sun, 17 Jun 2007 20:16:27 -0400
From: Dave Jones <davej@redhat.com>
To: Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070618001627.GA18598@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com
References: <20070614011506.GA30566@alinoe.com> <20070617162235.GA5486@alinoe.com> <20070617190714.GA18115@redhat.com> <20070617195901.GA5689@alinoe.com> <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com> <20070617213355.GC3430@redhat.com> <20070617223649.GA31587@alinoe.com> <20070617224918.GC12483@redhat.com> <20070618000643.GA1375@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618000643.GA1375@alinoe.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 02:06:43AM +0200, Carlo Wood wrote:
 > On Sun, Jun 17, 2007 at 06:49:18PM -0400, Dave Jones wrote:
 > > ok, then you must have CONFIG_AGP=y
 > 
 > I do - not voluntary however. For some mysterious reason I am
 > unable to set it to n or m.

You likely have CONFIG_IOMMU set. This makes AGP non-optional.

 > I am also not able to set CONFIG_AGP_INTEL
 > to n, only to y or m.
 > (using make 'menuconfig' for example).

Can't explain that one.

 > >  > Hence, in the case that the kernel works, intel-agp is loaded
 > >  > WITHOUT printing this Detected line
 > > 
 > > That doesn't make much sense.  The hardware doesn't change between
 > > a working & not-working kernel, and somehow the PCI probing fails.
 > > Hmm, do you have CONFIG_EDAC set ?
 > 
 > CONFIG_EDAC=m
 > 
 > $ lsmod | grep edac

ok, red herring.

 > > There's an outstanding bug (well, lack of feature) , where it claims
 > > the PCI device before AGP gets a chance to.
 > > This is unrelated to your hang however, but would at least explain
 > > the inconsistent probing.
 > > 
 > >  > Perhaps my "solution" is to remove this module completely?
 > >  > I don't seem to need it.
 > > 
 > > It's needed only for 3d,
 > 
 > Nope - I just played UT2004 without problems, and without intel-agp loaded.

Using the nvidia driver? It has its own built-in AGP support which will
get used if the kernel AGP support is missing.

 > > but it'd be good to figure out why its so
 > > broken on your system, even if you don't need it.
 > 
 > Please tell me what to do / try.
 > I'm an experienced coder - but I never really played with the
 > kernel before - so you'll have to spell out how to turn on debugging etc.

Right now, I'm at a loss to explain the corruption, so it's
difficult to suggest what to try.

	Dave

-- 
http://www.codemonkey.org.uk
