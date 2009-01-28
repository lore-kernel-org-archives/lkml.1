Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZA1RPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZA1RPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZA1RPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:15:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:54035 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZA1RPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:15:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,339,1231142400"; 
   d="scan'208";a="382105662"
From: "Luck, Tony" <tony.luck@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
CC: Rick Jones <rick.jones2@hp.com>, David Miller <davem@davemloft.net>,
       "tj@kernel.org" <tj@kernel.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "brgerst@gmail.com" <brgerst@gmail.com>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "travis@sgi.com" <travis@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "mathieu.desnoyers@polymtl.ca" <mathieu.desnoyers@polymtl.ca>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Wed, 28 Jan 2009 09:15:08 -0800
Subject: RE: [PATCH] percpu: add optimized generic percpu accessors
Thread-Topic: [PATCH] percpu: add optimized generic percpu accessors
Thread-Index: AcmBasGfweyc+KCeQn6s7srqPjs15wAAHiIA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35F317910@orsmsx505.amr.corp.intel.com>
References: <200901271213.18605.rusty@rustcorp.com.au>
 <497E705B.5000302@kernel.org> <alpine.DEB.1.10.0901271506580.3114@qirst.com>
 <20090127.134747.153565246.davem@davemloft.net> <497F8F02.9000603@hp.com>
 <57C9024A16AD2D4C97DC78E552063EA35F317617@orsmsx505.amr.corp.intel.com>
 <alpine.DEB.1.10.0901281146260.13825@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0901281146260.13825@qirst.com>
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

> > Managing a larger space could be done ... but at the expense of making
> > the Alt-DTLB miss handler do a memory lookup to find the physical address
> > of the per-cpu page needed (assuming that we allocate a bunch of random
> > physical pages for use as per-cpu space rather than a single contiguous
> > block of physical memory).
>
> We cannot resize the area by using a single larger TLB entry?

Yes we could ... the catch is that the supported TLB page sizes go
up by multiples of 4.  So if 64K is not enough the next stop is
at 256K, then 1M, then 4M, and so on.

That's why I asked when we know what total amount of per-cpu memory
is needed.  CONFIG time or boot time is good, because allocating higher
order pages is easy at boot time.  Arbitrary run time is bad because
we might have difficulty allocating a high order page for every cpu.

-Tony
