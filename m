Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbXKAI25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbXKAI25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 04:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXKAI2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 04:28:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55919 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbXKAI2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 04:28:48 -0400
Subject: Re: [v4l-dvb-maintainer] bttv build error (CONFIG_NET=n)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Trent Piepho <xyzzy@speakeasy.org>, v4l-dvb-maintainer@linuxtv.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20071031092350.91eae067.randy.dunlap@oracle.com>
References: <20071030221508.3139ea5c.randy.dunlap@oracle.com>
	 <Pine.LNX.4.58.0710310345160.19072@shell4.speakeasy.net>
	 <20071031092350.91eae067.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 06:28:29 -0200
Message-Id: <1193905709.8587.24.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.1-1mdv2008.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy,

> > The only reason the net stuff works, is because CONFIG_NET includes igmp.c,
> > which can't be compiled as a module.  That means ip_compute_csum() will get
> > pulled out of the lib.a file for igmp, and thus be present for the net modules
> > that use it too.  If igmp could be turned off, made a module, or stopped using
> > ip_compute_csum(), then the users of ip_compute_csum() that do depend on
> > CONFIG_NET would have the same problem as bttv does.
> 
> Thanks for the analysis and summary.
> (I'm still waiting for those lkml.org links to load... timed out)
> 
> > It seems a shame to create a new ip checksum function in the bttv driver when
> > a perfectly good one already exists and will already be present in just about
> > every kernel out there.  Honestly, how common is NET=n and VIDEO_BT848=m
> > outside of randconfig?

This might happen on embedded devices, like a set top box or a PVR,
using a bttv hardware.

> so just adding "depends on NET" should be OK then?

Seems very weird to have bttv module dependent on NET, just because a
checksum calculus function is defined there. 

One possible solution would be to move this function to another place
and having both NET, BTTV and other places selecting it.

-- 
Cheers,
Mauro

