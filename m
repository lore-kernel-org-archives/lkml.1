Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab0CJRve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:51:34 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:17884 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564Ab0CJRvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:51:33 -0500
X-IronPort-AV: E=Sophos;i="4.49,615,1262563200"; 
   d="scan'208";a="9883042"
Date: Wed, 10 Mar 2010 17:55:40 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: =?ISO-8859-15?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 0 of 5] PV on HVM Xen
In-Reply-To: <20100310173339.GO1878@reaktio.net>
Message-ID: <alpine.DEB.2.00.1003101739480.28412@kaball-desktop>
References: <alpine.DEB.2.00.1003101457100.28412@kaball-desktop> <20100310173339.GO1878@reaktio.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="8323329-1488125926-1268243740=:28412"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-1488125926-1268243740=:28412
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT

On Wed, 10 Mar 2010, Pasi Kärkkäinen wrote:
> On Wed, Mar 10, 2010 at 03:46:54PM +0000, Stefano Stabellini wrote:
> > Hi all,
> > this is a reduced and rebased version of the patch series I sent
> > yesterday "enhanced PV on HVM": this series is based on Linux 2.5.32 and
> > can be applied now, it includes everything but the pirq remapping
> > related functions that are not ready to be upstreamed at the moment.
> > 
> > Therefore it just achieves the goal of enabling PV devices in Linux
> > running in a Xen HVM domain, it doesn't allow event channels delivery in
> > place of interrupts.
> > 
> > The patch series consists of 5 patches, each patch comes with a detailed
> > description.
> > In order for this to work we also need a patch for Xen, that is being
> > worked on as we speak.
> >
> 
> Hmm.. is it possible to get PV-on-HVM drivers working on older Xen versions,
> that don't have additional patches? 
> 
> Just like the unmodified_drivers works for 2.6.18 and 2.6.27.
> 

The problem is that the old unmodified_drivers use a normal interrupt
from the xen pci platform device to receive event channels, and this
doesn't play well with the idea of remapping all the interrupts with
event channels, that is one if the main goals of the previous "enhanced"
patch series.
For this reason the new PV on HVM patch series sets up a new vector
based callback mechanism.

However it might be still possible to provide an additional, backward
compatible, delivery mechanism in case the new one fails.
I'll try to explore this option.

--8323329-1488125926-1268243740=:28412--
