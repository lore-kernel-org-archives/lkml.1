Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbXJZTKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbXJZTKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXJZTKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:10:37 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:17718 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbXJZTKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:10:36 -0400
X-IronPort-AV: E=Sophos;i="4.21,335,1188802800"; 
   d="scan'208";a="183221548"
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net, kernel-stuff@comcast.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Rt2400-devel] [PATCH] rt2500usb - Don't claim 050d:705{0/a}
X-Message-Flag: Warning: May contain useful information
References: <alpine.DEB.0.99.0710241909250.18618@parag-desktop>
	<200710252315.49427.IvDoorn@gmail.com>
	<alpine.DEB.0.99.0710251837040.9840@parag-desktop>
	<200710262039.17027.IvDoorn@gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 26 Oct 2007 12:10:15 -0700
In-Reply-To: <200710262039.17027.IvDoorn@gmail.com> (Ivo van Doorn's message of "Fri, 26 Oct 2007 20:39:16 +0200")
Message-ID: <adamyu5zo88.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Oct 2007 19:10:16.0296 (UTC) FILETIME=[D7B48680:01C81803]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Well it could be something quite simple, in the module loader it is looping
 > through all modules to look for a device with the correct USB/PCI ID.
 > Currently, after the first occurence it loads the module and doesn't continue,
 > it should perhaps be relatively easy that it checks if the driver returned -ENODEV
 > and continues looping to search for another driver.

But a driver (especially a driver for something as hot-pluggable as a
USB device) shouldn't return -ENODEV just because no devices are
present at the moment.  It should just load successfully and wait for
a device to appear.

 - R.
