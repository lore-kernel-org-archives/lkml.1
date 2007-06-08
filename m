Return-Path: <linux-kernel-owner+w=401wt.eu-S968032AbXFHI5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968032AbXFHI5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966731AbXFHI5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:57:34 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:32920 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966712AbXFHI5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:57:33 -0400
Message-ID: <466919FB.8080204@s5r6.in-berlin.de>
Date: Fri, 08 Jun 2007 10:57:31 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: multithreaded device matching with dependency
References: <1181300879.8064.25.camel@caritas-dev.intel.com>
In-Reply-To: <1181300879.8064.25.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> This is another solution to implement multithreaded device matching
> (probing). The device matching is delayed until all drivers are
> registered. The driver registering is executed one by one, this
> eliminates the potential of interdependency between driver. All devices
> are matched to drivers afterwards, multithreaded. The parent <->
> children relationship between devices is used as the dependency between
> devices, that is, the children devices matching will not begin until
> parent device matching finishes.

How can subsystems control multithreaded vs. singlethreaded probes?

For example, the IEEE 1394 subsystem should probe different nodes in
parallel, but different units on the same node serially.  Similar
requirements exist with other hardware.

Also, how can subsystems enable and disable multithreaded probes?

...
> +EXPORT_SYMBOL_GPL(device_match_freeze);
> +EXPORT_SYMBOL_GPL(device_match_thaw);

Their definitions lack kerneldoc comments.
-- 
Stefan Richter
-=====-=-=== -==- -=---
http://arcgraph.de/sr/
