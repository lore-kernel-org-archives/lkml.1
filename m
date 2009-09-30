Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZI3WFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZI3WFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZI3WFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:05:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:60117 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361AbZI3WFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:05:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,482,1249282800"; 
   d="scan'208";a="555530520"
From: "Luck, Tony" <tony.luck@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
CC: Tejun Heo <teheo@suse.de>, Nick Piggin <npiggin@suse.de>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 30 Sep 2009 15:05:43 -0700
Subject: RE: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic
 percpu and drop the old one, take#2
Thread-Topic: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic
 percpu and drop the old one, take#2
Thread-Index: AcpCD+et5X0AeNm2RLa4hdwXyo2iqwACTD8w
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E2F03FDC@orsmsx505.amr.corp.intel.com>
References: <1253682382-24740-1-git-send-email-tj@kernel.org>
 <4AC153EA.2050007@suse.de>
 <57C9024A16AD2D4C97DC78E552063EA3E2F03E58@orsmsx505.amr.corp.intel.com>
 <alpine.DEB.1.10.0909301644460.9271@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0909301644460.9271@gentwo.org>
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

> Tony: Could we use a global register for the per cpu address? That would
> make IA64 work similar to sparc.

Would that be a useful trade of resources for convenience?  We've already
hard-wired r13 for "current". Grabbing another one would require fixing
(since user code will have clobbered it).  Possibly re-working any existing
code that already uses whatever register you choose.

How would that compare with using [r13]?

We might have a krN free ... but kregs are a lot slower than real registers.

-Tony
