Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbZIALMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbZIALMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZIALMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:12:24 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:58190 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbZIALMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JFkGTkzbskJxax+qZ0XFGBr7BqiSuq18ExleEcmYT0jzd/QpCACl7LkRBL+0K6Oknc
         2cS5IDAxzp0llv6kv44b0A+3mG6aGUgwB7zSBCljXb7G7K9JHOuUZg7Wp++tZeAx2100
         8NPuSUDz+ZlWVUvmzVzDu2nREXlxBh70a1bQo=
MIME-Version: 1.0
In-Reply-To: <1251741624.18828.83.camel@mulgrave.site>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <1251739735.16169.20.camel@ank32.eng.vmware.com>
	 <1251741624.18828.83.camel@mulgrave.site>
Date: Tue, 1 Sep 2009 13:12:24 +0200
X-Google-Sender-Auth: 8611d1db0ed427a0
Message-ID: <e2e108260909010412p41fae86ckb6df5cd8a81e3c37@mail.gmail.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
From: Bart Van Assche <bvanassche@acm.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: akataria@vmware.com, Robert Love <robert.w.love@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dtor@vmware.com>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Maxime Austruy <maustruy@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 8:00 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
>
> On Mon, 2009-08-31 at 10:28 -0700, Alok Kataria wrote:
> > VMware PVSCSI driver - v2.
>
> OK, so the first thing that springs to mind is that we already have one
> of these things: the ibmvscsi ... is there no way we can share code
> between this and the other PV drivers?

Good question. But shouldn't the ibmvscsi driver be refactored before
considering sharing ibmvscsi code with other paravirtualized drivers ?
A quote from the ibmvscsi.c source code:

 * TODO: This is currently pretty tied to the IBM i/pSeries hypervisor
 * interfaces.  It would be really nice to abstract this above an RDMA
 * layer.

Splitting the ibmvscsi.c driver in an SRP initiator and an RDMA driver
would make the following possible:
- Reuse the existing SRP initiator (ib_srp). Currently there are two
SRP initiators present in the Linux kernel -- one that uses the RDMA
verbs API (ib_srp) and one that only works with IBM's i/pSeries
hypervisor (ibmvscsi).
- Reuse the ib_ipoib kernel module to provide an IP stack on top of
the new RDMA driver instead of having to maintain a separate network
driver for this hardware (ibmveth).

More information about the architecture the ibmvscsi and the ibmveth
drivers have been developed for can be found in the following paper:
D. Boutcher and D. Engebretsen, Linux Virtualization on IBM POWER5
Systems, Proceedings of the Linux Symposium, Vol. 1, July 2004, pp.
113-120 (http://www.kernel.org/doc/mirror/ols2004v1.pdf).

Bart.
