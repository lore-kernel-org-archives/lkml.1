Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbZFOBsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbZFOBsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 21:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbZFOBsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 21:48:11 -0400
Received: from mga05.intel.com ([192.55.52.89]:58027 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750832AbZFOBsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 21:48:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,219,1243839600"; 
   d="scan'208";a="699301495"
Subject: Re: [PATCH V4: 1/3] pci: Provide Multiple Error Received and no
	error source id support on AER
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1244845057.19708.116.camel@grinch>
References: <1244776109.2560.319.camel@ymzhang>
	 <1244845057.19708.116.camel@grinch>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 15 Jun 2009 09:48:15 +0800
Message-Id: <1245030495.2560.344.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 22:17 +0000, Andrew Patterson wrote:
> On Fri, 2009-06-12 at 11:08 +0800, Zhang, Yanmin wrote:
> > Anyone could help me test it on powerpc? Or at least a compilation
> > to see there is any compiling error/warning. I have no powerpc machine.
> > Thanks.
> > 
> > Changelog V4:
> > 	Port the patches to Jesses' linux-next tree (mostly based on
> > 	2.6.30).
> > 
> > ﻿﻿Changelog V3:
> >         1) Probe devices under the root port when the bus id of
> >         the source id is equal to 0; V2 does so when device id is
> >         equal to 0;
> >         2) Add more comments on critical path of finding devices.
> > 
> > ﻿Changelog V2:
> >         Version 2 adds nosourceid, a boot parameter. When
> >         aerdriver.nosourceid=y, aerdriver doesn't use the source
> >         id saved by root port. Instead, it searches the device
> >         tree under the root port to find the reporter. So if hardware
> >         has errata and root port saves a bad source id, aerdriver
> >         still could find the reporter.
> >         There are 2 scenarios under which ﻿aerdriver searches the
> >         device tree under root port:
> >         1) nosourceid=n and error source id is equal to 0;
> >         2) nosourceid=y.
> > 
> > ﻿Based on PCI Express AER specs, a root port might receive multiple
> > TLP errors while it could only save a correctable error source id
> > and an uncorrectable error source id at the same time. In addition,
> > some root port hardware might be unable to provide a correct source
> > id, i.e., the source id, or the bus id part of the source id provided
> > by root port might be equal to 0.
> > 
> > The patchset implements the support in kernel by searching the device
> > tree under the root port.
> > 
> > Patch 1 changes parameter cb of function pci_walk_bus to return a value.
> > When cb return non-zero, pci_walk_bus stops more searching on the
> > device tree.
> > 
> > ﻿﻿﻿Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>
> > 
> 
> This one looks fine to me. 
> 
> Reviewed-by: Andrew Patterson <andrew.patterson@hp.com>
Thanks for helping review the patches.

Yanmin


