Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZHLS3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZHLS3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZHLS3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:29:30 -0400
Received: from mail-yw0-f193.google.com ([209.85.211.193]:44262 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbZHLS3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:29:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=Nm6MM6rosdpdKreNluVvtZOKIYVAB5jq77snqV5AJkKQLBlZLyhxKHr2mHCylCrYRq
         7xkhpv1KGPd3Buxwc2dsDQvwIMZXyf/igYNXuOg90MFlb6gGDgrV5i3zNQ+CzsegQbi3
         dDZ4Gkq0tR9kWT9wfUZKC96sUTh35awp/s+2s=
Subject: Re: Patch "page-allocator: preserve PFN ordering when __GFP_COLD
 is set" fails on my system
From: Arnaud Faucher <arnaud.faucher@gmail.com>
Reply-To: 200908121735.44439.jbe@pengutronix.de
To: Juergen Beisert <jbe@pengutronix.de>, Mel Gorman <mel@csn.ul.ie>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 12 Aug 2009 14:29:27 -0400
Message-Id: <1250101767.4628.22.camel@green>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a rather similar problem on a driver that I try to keep
up-to-date with recent kernel versions
(http://code.ximeta.com/trac-ndas/ticket/1110#comment:30). The NDAS
hardware is an ethernet-enabled disk controller on one chip, kind of a
cheap iSCSI.

In my case there is no oops: the symptoms are that the read blocks seem
to be swapped or full of garbage.

After investigation in the NDAS code, the bug triggers when the driver
tries to merge adjacent requests, before sending them to the controller.
I had to disable this merge in order to restore normal behavior, at the
expense of a reduced efficiency.

Mel's buffer overrun theory seems to apply in the NDAS driver case,
where the original requests adjacency test seems faulty.

May it also be the cause of the SD mounting crash ?

