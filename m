Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZIAQMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZIAQMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZIAQMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:12:45 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:31313 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZIAQMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:12:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIfknEqrR7MV/2dsb2JhbADEaIhBAZAFBYQb
X-IronPort-AV: E=Sophos;i="4.44,313,1249257600"; 
   d="scan'208";a="379797447"
From: Roland Dreier <rdreier@cisco.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <James.Bottomley@suse.de>, akataria@vmware.com,
       Robert Love <robert.w.love@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dtor@vmware.com>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Maxime Austruy <maustruy@vmware.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	<1251739735.16169.20.camel@ank32.eng.vmware.com>
	<1251741624.18828.83.camel@mulgrave.site>
	<e2e108260909010412p41fae86ckb6df5cd8a81e3c37@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 01 Sep 2009 09:12:43 -0700
In-Reply-To: <e2e108260909010412p41fae86ckb6df5cd8a81e3c37@mail.gmail.com>
	(Bart Van Assche's message of "Tue, 1 Sep 2009 13:12:24 +0200")
Message-ID: <adaws4iod8k.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Sep 2009 16:12:44.0267 (UTC) FILETIME=[09D8E3B0:01CA2B1F]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > - Reuse the existing SRP initiator (ib_srp). Currently there are two
 > SRP initiators present in the Linux kernel -- one that uses the RDMA
 > verbs API (ib_srp) and one that only works with IBM's i/pSeries
 > hypervisor (ibmvscsi).

This would be sane, although the difference in management APIs etc made
this seem like quite a bit of work when I looked at it (hence the
existence of both ibmvscsi and ib_srp).

 > - Reuse the ib_ipoib kernel module to provide an IP stack on top of
 > the new RDMA driver instead of having to maintain a separate network
 > driver for this hardware (ibmveth).

I don't think this really makes sense, because IPoIB is not really
handling ethernet (it is a different L2 ethernet encapsulation), and I
think the commonality with ibmveth is going to be minimal.

I'm not really sure we should be trying to force drivers to share just
because they are paravirtualized -- if there is real commonality, then
sure put it in common code, but different hypervisors are probably as
different as different hardware.

 - R.
