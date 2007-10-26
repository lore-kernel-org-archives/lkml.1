Return-Path: <linux-kernel-owner+w=401wt.eu-S1763339AbXJZUGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763339AbXJZUGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXJZUF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:05:56 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:62767 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbXJZUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:05:55 -0400
X-IronPort-AV: E=Sophos;i="4.21,335,1188802800"; 
   d="scan'208";a="183235173"
To: Adam Baker <linux@baker-net.org.uk>
Cc: rt2400-devel@lists.sourceforge.net, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-stuff@comcast.net
Subject: Re: [Rt2400-devel] [PATCH] rt2500usb - Don't claim 050d:705{0/a}
X-Message-Flag: Warning: May contain useful information
References: <alpine.DEB.0.99.0710241909250.18618@parag-desktop>
	<200710262039.17027.IvDoorn@gmail.com> <adamyu5zo88.fsf@cisco.com>
	<200710262058.56188.linux@baker-net.org.uk>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 26 Oct 2007 13:05:54 -0700
In-Reply-To: <200710262058.56188.linux@baker-net.org.uk> (Adam Baker's message of "Fri, 26 Oct 2007 20:58:56 +0100")
Message-ID: <adaejfhzlnh.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Oct 2007 20:05:54.0614 (UTC) FILETIME=[9D7F6D60:01C8180B]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > The function that is returning ENODEV is the driver probe function. According 
 > to Documentation/DocBook/writing_usb_driver/ch03.html when that function is 
 > called 
 > 
 > "The driver now needs to verify that this device is actually one that it can 
 > accept. If so, it returns 0. If not, or if any error occurs during 
 > initialization, an errorcode (such as -ENOMEM or -ENODEV) is returned from 
 > the probe function."
 > 
 > It isn't a device the driver can accept so it returns -ENODEV

That's all true but irrelevant.  That error return isn't propagated
back to userspace when it runs modprobe (and in fact it *can't* be
sanely returned to userspace -- what do you do if the probe function
succeeds for two devices and fails for a third?).  So there's not
really any way for userspace to loop through a list of modules until
one succeeds.
