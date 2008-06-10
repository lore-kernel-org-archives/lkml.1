Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYFJJV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYFJJV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYFJJVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:21:49 -0400
Received: from ozlabs.org ([203.10.76.45]:48385 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbYFJJVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:21:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18510.18338.20232.969001@cargo.ozlabs.ibm.com>
Date: Tue, 10 Jun 2008 19:21:38 +1000
From: Paul Mackerras <paulus@samba.org>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       general@lists.openfabrics.org, "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, TKLEIN@de.ibm.com,
       fenkes@de.ibm.com, raisch@de.ibm.com, THEMANN@de.ibm.com
Subject: Re: [PATCH 0/2] Prevent loss of interrupts in IB/ehca
In-Reply-To: <200806101021.28795.ossrosch@linux.vnet.ibm.com>
References: <200806091742.29421.ossrosch@linux.vnet.ibm.com>
	<18509.44672.668946.207110@cargo.ozlabs.ibm.com>
	<200806101021.28795.ossrosch@linux.vnet.ibm.com>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Roscher writes:

> The processing of events with a timer controlled polling is not the "typical"
> way how you should handle adapter events.

Do you mean it's not typical in Linux (I would have said it was), or
it's not the way that the firmware architects and implementers thought
the eHEA hcalls would be used?

> During corner case testing, we noticed that some versions of ehca 
> do not properly transition to interrupt done in special load situations.
> This can be resolved by periodically triggering EOI through H_EOI, 
> if eqes are pending.

So in other words, doing the extra EOIs is a workaround for a firmware
and/or hardware bug, then?  If that's the case then you needed to say
that in the commit message.

Given that the ehea driver does hcalls itself directly, and this is a
workaround for a firmware/hardware bug, it may actually be cleaner
just to have the ehea driver do the necessary H_EOI calls directly.

Paul.
