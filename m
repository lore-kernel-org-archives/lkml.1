Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbZIAQeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbZIAQeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbZIAQea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:34:30 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:34850 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZIAQe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qp43p2DWT/Ei39GqZFBWNo+3Cjj9h00jI8wF3+2lVL9fK0yin1AIE6eB1VHKNMvJ7E
         jfbhS0+o/fMzC+R1VQonyehYPHt1kOHfJgEbk7vE/LJKoNDQwrNyS5QM4LUo6rVfx4f3
         Qlhqyq3+cOpgQ+I0Z47CePSzV8aWVT+a7WflI=
MIME-Version: 1.0
In-Reply-To: <adaws4iod8k.fsf@cisco.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <1251739735.16169.20.camel@ank32.eng.vmware.com>
	 <1251741624.18828.83.camel@mulgrave.site>
	 <e2e108260909010412p41fae86ckb6df5cd8a81e3c37@mail.gmail.com>
	 <adaws4iod8k.fsf@cisco.com>
Date: Tue, 1 Sep 2009 18:34:30 +0200
X-Google-Sender-Auth: 8215e5e431a544e5
Message-ID: <e2e108260909010934k7be05930lfa544ea914224cf1@mail.gmail.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
From: Bart Van Assche <bvanassche@acm.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: James Bottomley <James.Bottomley@suse.de>, akataria@vmware.com,
       Robert Love <robert.w.love@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dtor@vmware.com>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Maxime Austruy <maustruy@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 1, 2009 at 6:12 PM, Roland Dreier <rdreier@cisco.com> wrote:
>  > - Reuse the ib_ipoib kernel module to provide an IP stack on top of
>  > the new RDMA driver instead of having to maintain a separate network
>  > driver for this hardware (ibmveth).
>
> I don't think this really makes sense, because IPoIB is not really
> handling ethernet (it is a different L2 ethernet encapsulation), and I
> think the commonality with ibmveth is going to be minimal.

What I had in mind was not to start searching for code shared between
the ipoib and ibmveth kernel modules, but to replace the virtual
Ethernet layer by IPoIB on top of a new RDMA driver. I'm not sure
however this approach would work better than the currently implemented
approach in ibmveth.

> I'm not really sure we should be trying to force drivers to share just
> because they are paravirtualized -- if there is real commonality, then
> sure put it in common code, but different hypervisors are probably as
> different as different hardware.

Agreed. But several people are currently looking at how to improve the
performance of I/O performed inside a virtual machine without being
familiar with the VIA architecture or the RDMA API. This is a pity
because the Virtual Interface Architecture was designed to allow
high-throughput low-latency I/O, and has some features that are not
present in any other mainstream I/O architecture I know of (e.g. the
ability to perform I/O from userspace without having to invoke any
system call in the performance-critical path).

Bart.
