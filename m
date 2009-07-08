Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZGHNSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZGHNSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 09:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZGHNSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 09:18:11 -0400
Received: from fmailhost05.isp.att.net ([207.115.11.55]:63158 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZGHNSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 09:18:10 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A549C9B.4060702@lwfinger.net>
Date: Wed, 08 Jul 2009 08:18:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: David Rientjes <rientjes@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>	 <bXZeuxPQAWE.A.Y2.2BpUKB@chimera> <4A529F60.7010509@lwfinger.net>	 <alpine.DEB.2.00.0907062302540.10840@chino.kir.corp.google.com> <84144f020907062357m6a75d2eav1589e7f8b4a3d887@mail.gmail.com>
In-Reply-To: <84144f020907062357m6a75d2eav1589e7f8b4a3d887@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> 
> Yup, if it's not too much trouble Larry, I'd appreciate if you gave it
> a spin before I apply the sucker. Note to regression trackers, I don't
> think this should go to -stable because it depends on other patches in
> mainline and there's an obvious workaround for the problem (disable
> CONFIG_SLUB_DEBUG_ON). Furthermore, it's very unlikely people will hit
> this on production configurations anyway.

Pekka,

I have been running the patch for ~24 hours with slub_debug=0 as a
boot option. So far, no problems. My workload has not involved as many
network operations as some times, but my memory has not fragmented.
The output of 'cat /proc/buddyinfo' is as follows:

Node 0, zone      DMA      8      5      5      4      5      5      5
     4      3      0      1
Node 0, zone    DMA32   1804   1585   3007     36      0      0      0
     0      1      0      0

As might be expected, the high-order fragments are gone, but the O(1)
pieces have not been depleted.

Larry

