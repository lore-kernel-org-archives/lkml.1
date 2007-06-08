Return-Path: <linux-kernel-owner+w=401wt.eu-S969309AbXFHOMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969309AbXFHOMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968846AbXFHOMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:12:40 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:33733 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969089AbXFHOMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:12:39 -0400
Message-ID: <466963D4.6010008@s5r6.in-berlin.de>
Date: Fri, 08 Jun 2007 16:12:36 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] driver core: multithreaded device matching with dependency
References: <9D7649D18729DE4BB2BD7B494F7FEDC2041245@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <9D7649D18729DE4BB2BD7B494F7FEDC2041245@pdsmsx415.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
>>From: Stefan Richter [mailto:stefanr@s5r6.in-berlin.de]
>>
>>How can subsystems control multithreaded vs. singlethreaded probes?
>>
>>For example, the IEEE 1394 subsystem should probe different nodes in
>>parallel, but different units on the same node serially.  Similar
>>requirements exist with other hardware.
> 
> For subsystems specific dependency problems, a field as follow can be
> added into struct device:
> 
> struct device *depend;
> 
> The parallel device probing code will not do probing for the device,
> unless the device pointed by "depend" has been probed,

A bad API.  Subsystems and the driver core will both traverse the trees
(usually just lists) which can be built from the depend pointers, and
the trees grow and shrink dynamically.  Perhaps it would be simpler if
the subsystem would just use a mutex per group of devices which have to
be serialized.

*However*, IMO parallelized probing should be implemented in the
subsystems themselves in the first place, _not in the driver core_.

The subsystems know where parallelism is possible and safe and
effective, the driver core doesn't.
-- 
Stefan Richter
-=====-=-=== -==- -=---
http://arcgraph.de/sr/
