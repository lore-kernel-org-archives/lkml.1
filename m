Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbZBLO6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbZBLO6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbZBLO5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:57:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:62803 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390AbZBLO5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:57:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,197,1233561600"; 
   d="scan'208";a="430446058"
Subject: [PATCH NET-NEXT 0/10] hardware time stamping with new fields in
	shinfo
From: Patrick Ohly <patrick.ohly@intel.com>
To: David Miller <davem@davemloft.net>
Cc: John Stultz <johnstul@us.ibm.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain
Date: Thu, 12 Feb 2009 15:57:50 +0100
Message-Id: <1234450670.5914.9.camel@ecld0pohly>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This revision of the patch series transports hardware time stamps from
the hardware into user space via additional fields in struct
skb_shared_info. It's based on net-next-2.6 as of this morning.

This is the solution that emerged from the discussion of the other
approaches suggested before (reuse tstamp, extend skbuff, optional
structs): it has the advantage of not touching skbuff and also has the
simplest implementation.

The clocksource and timecompare patches have been reviewed by John
Stultz. He doesn't mind merging them via the net subtree.

John Ronciak reviewed the igb driver patches. He suggested to merge the
patches as they; after all, PTPd already works fine. I just tested again
on 32 and 64 bit x86, both with the timestamping example programs as
well as with PTPd. Latest patched PTPd is here:
        http://github.com/pohly/ptpd/tree/master

The open TODOs in the igb driver will be fixed. We think that this will
be easier with the infrastructure and the driver in a regular kernel
tree.

David, I hope you consider the patches acceptable now. If not, then as
before: please let me know what I can do to make them acceptable.

-- 
Best Regards, Patrick Ohly

The content of this message is my personal opinion only and although
I am an employee of Intel, the statements I make here in no way
represent Intel's position on the issue, nor am I authorized to speak
on behalf of Intel on this matter.

