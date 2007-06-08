Return-Path: <linux-kernel-owner+w=401wt.eu-S938113AbXFHJ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938113AbXFHJ2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 05:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932937AbXFHJ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 05:28:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:2585 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbXFHJ2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 05:28:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,399,1175497200"; 
   d="scan'208";a="236985230"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] driver core: multithreaded device matching with dependency
Date: Fri, 8 Jun 2007 17:27:34 +0800
Message-ID: <9D7649D18729DE4BB2BD7B494F7FEDC2041245@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <466919FB.8080204@s5r6.in-berlin.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] driver core: multithreaded device matching with dependency
Thread-Index: Acepqw/YOfRjYUUbSEu/xZFH1ybEZwAA7+pQ
From: "Huang, Ying" <ying.huang@intel.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
X-OriginalArrivalTime: 08 Jun 2007 09:27:35.0107 (UTC) FILETIME=[3F617130:01C7A9AF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Stefan Richter [mailto:stefanr@s5r6.in-berlin.de]
>
>How can subsystems control multithreaded vs. singlethreaded probes?
>
>For example, the IEEE 1394 subsystem should probe different nodes in
>parallel, but different units on the same node serially.  Similar
>requirements exist with other hardware.

For subsystems specific dependency problems, a field as follow can be
added into struct device:

struct device *depend;

The parallel device probing code will not do probing for the device,
unless the device pointed by "depend" has been probed, that is, they are
probed serially. As for IEEE 1394 subsystem, when the subsystem adds new
devices, the different units on the same node are linked together with
the "depend" field, so that they can be probed serially. So do other
subsystems.

>Also, how can subsystems enable and disable multithreaded probes?

If subsystem needs strictly serial probing, it can accomplish this
through "depend" field as mentioned above.

>> +EXPORT_SYMBOL_GPL(device_match_freeze);
>> +EXPORT_SYMBOL_GPL(device_match_thaw);
>
>Their definitions lack kerneldoc comments.

Sorry, I will add it in the next version.

Best Regards,
Huang Ying
