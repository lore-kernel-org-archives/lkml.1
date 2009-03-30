Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbZC3OcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbZC3OcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZC3Obf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:31:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:28343 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271AbZC3Obd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:31:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,446,1233561600"; 
   d="scan'208";a="398693722"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "neilb@suse.de" <neilb@suse.de>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Mar 2009 15:30:47 +0100
Subject: RE: [PATCH 09/13] iop-adma: P+Q self test
Thread-Topic: [PATCH 09/13] iop-adma: P+Q self test
Thread-Index: Acmn/q96QOHNHb0bS26TUmzqyCm34wJNNWRA
Message-ID: <129600E5E5FB004392DDC3FB599660D790F8BF26@irsmsx504.ger.corp.intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
 <20090318192102.20375.36540.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090318192102.20375.36540.stgit@dwillia2-linux.ch.intel.com>
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

Williams, Dan J wrote:
> +	cookie = iop_adma_tx_submit(tx);
> +	iop_adma_issue_pending(dma_chan);
> +	msleep(8);

Why sleeping exactly 8 ms?
Has this value been somehow experiomentally obtained?
How about introducing wait_for_completion, just like it is in ioatdma now?

General remark:
Both iop_adma_pq_zero_sum_self_test() and iop_adma_xor_zero_sum_self_test()
are quite long and they consist of series of subsequent similar tests.
I guess the code would be easier to read if every test was a separate function
called from iop_adma_XX_zero_sum_self_test().

Regards,
Maciej
