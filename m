Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZDOUVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZDOUVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZDOUVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:21:04 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:26413 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbZDOUVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:21:03 -0400
X-IronPort-AV: E=Sophos;i="4.40,194,1238976000"; 
   d="scan'208";a="155141282"
Date: Wed, 15 Apr 2009 13:20:52 -0700
From: VomLehn <dvomlehn@cisco.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <lkml@rtr.ca>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090415202052.GA14325@cuplxvomd02.corp.sa.net>
References: <Pine.LNX.4.44L0.0904151146210.3072-100000@iolanthe.rowland.org> <49E60219.9080103@rtr.ca> <20090415170617.GA14485@cuplxvomd02.corp.sa.net> <20090415183252.32ba7a4f@lxorguk.ukuu.org.uk> <20090415130614.55b1cb28@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415130614.55b1cb28@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 01:06:14PM -0700, Arjan van de Ven wrote:
> For other pieces it's hard. Non-enumeratable busses just suck;
> at some point all you can do is just wait (which we have already 
> available today for anyone to do). I realize people don't want to
> just wait 4 seconds (the people who first objected to boot time
> improvements then suddenly care about boot time ;-)...

We can do better than just waiting. What we want to do is to wait
until a suitable device becomes available. For USB console, the patch
I submitted yesterday waits for the first console to be registered.
That might not be quite right, but it's a lot better than no console
at all. For network devices, we have to wait for a specific device and
I haven't had a chance to look at this. For both types of devices, we
can timeout after a reasonable interval, for some definition of reasonable.

Waiting for a suitable device preserves fast boot times, timing out allows
the system to come up enough to try to diagnose the problem.

David VomLehn
