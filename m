Return-Path: <linux-kernel-owner+w=401wt.eu-S1765813AbXGPQEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765813AbXGPQEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759518AbXGPQE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:04:29 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:55746 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379AbXGPQE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:04:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CABA0m0arR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.16,542,1175497200"; 
   d="scan'208"; a="166794553:sNHT29960820"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 01/10] IB/ehca: Support for multiple event queues
X-Message-Flag: Warning: May contain useful information
References: <200707121745.27592.fenkes@de.ibm.com>
	<200707121746.36763.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 16 Jul 2007 09:04:26 -0700
In-Reply-To: <200707121746.36763.fenkes@de.ibm.com> (Joachim Fenkes's message of "Thu, 12 Jul 2007 17:46:35 +0200")
Message-ID: <adalkdgz65x.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Jul 2007 16:04:26.0455 (UTC) FILETIME=[FBBF4E70:01C7C7C2]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > The eHCA driver can now handle multiple event queues (read: interrupt
 > sources) instead of one. The number of available EQs is selected via the
 > nr_eqs module parameter.

 > CQs are either assigned to the EQs based on the comp_vector index or, if the
 > dist_eqs module parameter is supplied, using a round-robin scheme.

Do you have any data on how well this round-robin assignment works?
It seems not quite right to me for the driver to advertise nr_eqs
completion vectors, but then if round-robin is turned on to ignore the
consumer's decision about which vector to use.

Maybe if round-robin is turned on you should report 0 as the number of
completion vectors?  Or maybe we should allow well-known values for
the completion vector passed to ib_create_cq to allow consumers to
specify a policy (like round robin) instead of a particular vector?
Maybe the whole interface is broken and we should only be exposing
policies to consumers instead of the specific vector?

I think I would rather hold off on multiple EQs for this merge window
and plan on having something really solid and thought-out for 2.6.24.

 - R.
