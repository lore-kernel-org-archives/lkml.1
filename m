Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbYEGVBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbYEGVBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760687AbYEGVAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:00:52 -0400
Received: from mga12.intel.com ([143.182.124.36]:4964 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765066AbYEGVAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:00:48 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 May 2008 17:00:48 EDT
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,450,1204531200"; 
   d="scan'208";a="243481757"
Date: Wed, 7 May 2008 13:58:18 -0700
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, jbarnes@virtuousgeek.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: intel-iommu: CONFIG_DMAR*=y kills my box
Message-ID: <20080507205818.GA15746@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <48133A64.7020702@googlemail.com> <4813660E.8080609@googlemail.com> <20080429002901.GC31157@linux.intel.com> <481677D3.5070800@googlemail.com> <20080429225348.GA1672@linux.intel.com> <4817A98D.8080007@googlemail.com> <20080506131554.4adb3f9c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506131554.4adb3f9c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 01:15:54PM -0700, Andrew Morton wrote:
> On Wed, 30 Apr 2008 01:04:45 +0200
> Gabriel C <nix.or.die@googlemail.com> wrote:
> >
> 
> Guys, it's really painful having to scroll through thousand-line emails to
> find a few lines of information.  Please trim stuff.

sorry.  I will next time.
 
> > 
> > > 
> > > I do find it quite odd that a DMA code path specific to PCIE is somehow
> > > in the loop for a parallel port device.  Should this be possible?
> > 
> > I have no idea =) ( PCI folks added to CC )
> > 
> > > 
> > > I could easily be wrong so feel free to correct me but;
> > > I think your bios is goofy / unprepared to support IOMMU / VT-d and
> > > doing strange things with enumerated a parallel port on a PCIE bus with
> > > VTD is turned on...
> > 
> > I will contact ASUS peoples about the BIOS but it has for sure VT-d support and it is enabled.
> 
> So..  what happened here?  It seems like a pretty fatal problem, and
> personally I don't think that contacting vendors about BIOS upgrades is a
> suitable general solution.  It would be much better to find a kernel-based
> fix or workaround?
> 

We don't have a stable work around yet.  Unwrapping the IOMMU startup
code is proving tricky.  The only thing I can think of is to change the
polarity of the intel-iommu command line to default to off, and if your
bios doesn't suck you can enable it if you want to use it.

I don't like this option much, since all the issues have been bios
based.  But, I don't know what else to do at this time.

--mgross

