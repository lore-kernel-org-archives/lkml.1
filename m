Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYFOT3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYFOT3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 15:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYFOT3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 15:29:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:55524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbYFOT3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 15:29:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,648,1204531200"; 
   d="scan'208";a="341343981"
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Date: Sun, 15 Jun 2008 12:29:24 -0700
Subject: RE: [Bug 10843] Display artifacts on XOrg logout with PAT kernel
 and VESA framebuffer
Thread-Topic: [Bug 10843] Display artifacts on XOrg logout with PAT kernel
 and VESA framebuffer
Thread-Index: AcjOagd1F/1ie1zFTdi22wigMb5M/wAskbCw
Message-ID: <8B23168BCBB43B49A4C8EAB32D4B62F1061F3A82@orsmsx505.amr.corp.intel.com>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
 <Jn7irxIunJK.A._5D.LJDVIB@albercik> <200806142359.36613.elendil@planet.nl>
In-Reply-To: <200806142359.36613.elendil@planet.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Saturday 14 June 2008, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> >
> > Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=10843
> > Subject       : Display artifacts on XOrg logout with PAT kernel and VESA
> >                 framebuffer
> > Submitter     : Frans Pop <elendil@planet.nl>
> > Date          : 2008-05-31 14:04 (15 days old)
> > References    : http://lkml.org/lkml/2008/6/7/206
>
> Yes. See also: http://lkml.org/lkml/2008/6/13/159

Frans, With or with out pat, in the recent kernels (like 2.6.26-rc4/rc5 etc), ioremap()
uses  UC- and PCI mmap of /sys/devices/pci.../resource (used by X) uses UC-

And fb_mmap() also uses UC-.

It's interesting that you don't see this artifact with "nopat". Essentially with
or with out pat enabled, we use the same memory attributes. So depending on the
MTRR setup (set by X server), effective memory attribute across different mappings
should be same (which is UC- or WC with mtrr).

Can you also check, if there is any impact with kernel boot param for vesafb "mtrr:3"?

thanks,
suresh
