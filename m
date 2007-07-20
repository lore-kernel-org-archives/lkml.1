Return-Path: <linux-kernel-owner+w=401wt.eu-S933646AbXGTUBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbXGTUBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763771AbXGTUBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:01:37 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:52228 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762813AbXGTUBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:01:36 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Fri, 20 Jul 2007 22:03:27 +0200
User-Agent: KMail/1.9.7
Cc: Milton Miller <miltonm@bga.com>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Lang <david@lang.hm>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
References: <Pine.LNX.4.44L0.0707201408060.2546-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707201408060.2546-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707202203.27849.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 20 Juli 2007 schrieb Alan Stern:
> Some drivers need the ability to schedule.  Some will need the ability 
> to allocate memory (although GFP_ATOMIC is probably sufficient).  Some 
> will need timers to run.

Some will have to request firmware. It can add up to some megabytes.
In addition, if we don't freeze, some drivers, eg. video drivers, can
do allocations in the megabyte range.

It seems to me that without the freezer we will end up with many drivers
needing a two step notification process. Furthermore there are requirements
on the order of shutting down system facilities, eg. device addition must
be stopped before drivers allocate firmware.

	Regards
		Oliver

