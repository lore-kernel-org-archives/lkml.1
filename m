Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZHUMQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZHUMQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 08:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZHUMQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 08:16:30 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:43128 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbZHUMQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 08:16:29 -0400
X-IronPort-AV: E=Sophos;i="4.44,250,1249257600"; 
   d="scan'208";a="6711943"
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19086.35370.70561.378736@gianluca.uk.xensource.com>
Date: Fri, 21 Aug 2009 12:51:06 +0100
From: Gianluca Guida <gianluca.guida@citrix.com>
To: Miroslav Rezanina <mrezanin@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Gianluca Guida <Gianluca.Guida@eu.citrix.com>
Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
In-Reply-To: <1378245818.61101250842487688.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
References: <1152394510.61021250842386600.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<1378245818.61101250842487688.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Mailer: VM 8.0.12 under 22.3.1 (i486-pc-linux-gnu)
X-OriginalArrivalTime: 21 Aug 2009 12:16:30.0564 (UTC) FILETIME=[371E3240:01CA2259]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miroslav Rezanina writes:
 > ----- Original Message -----
 > From: "Jeremy Fitzhardinge" <jeremy@goop.org>
 > To: "Miroslav Rezanina" <mrezanin@redhat.com>
 > Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com, "Gianluca Guida" <gianluca.guida@citrix.com>
 > Sent: Thursday, August 20, 2009 6:39:02 PM GMT +01:00 Amsterdam / Berlin / Bern / Rome / Stockholm / Vienna
 > Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
 > 
 > On 08/20/09 00:47, Miroslav Rezanina wrote:
 > >> there is handled e820 map in guest. However, this patch informs 
 > >> hypervisor, that guest uses less memory than was assigned to it. 
 > >> If hypervisor is not informed, memory is reserved for guest that
 > >> do not need it. If hypervisor is informed, he decrease memory
 > >> reservation for guest and unused memory is marked as free 
 > >> for use by other guests.
 > >>   
 > >
 > > Yes.  But the guest will modify its own e820 map for a number of
 > > reasons; for example: reducing its own memory, or clearing a space for
 > > the PCI hole.  In general we want to free any underlying pages which
 > > don't correspond to E820_RAM regions.
 > >
 > >    J
 > 
 > I agree. However, I'm not sure if xen supports such a precise handling.

Xen will just get a list of mfn to remove from the domain. That is
precise enough. The scenario Jeremy is describing does happen,
especially in dom0 kernels.

G.
