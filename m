Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZG0ARM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZG0ARM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 20:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbZG0ARM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 20:17:12 -0400
Received: from fmailhost02.isp.att.net ([204.127.217.102]:54037 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbZG0ARL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 20:17:11 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A6CF220.7080605@lwfinger.net>
Date: Sun, 26 Jul 2009 19:17:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.Pi.BZObKB@chimera>
In-Reply-To: <H5-1lZIIeYK.A.Pi.BZObKB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13319
> Subject		: Page allocation failures with b43 and p54usb
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2009-04-29 21:01 (89 days old)
> References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
> 		  http://lkml.org/lkml/2009/6/7/136
> Handled-By	: Johannes Berg <johannes@sipsolutions.net>

This bug was fixed by commit 781b2ba6eb5f22440afac9c79a89ebd6e3674a60
entitled "SLUB: Out-of-memory diagnostics" by Pekka Enberg
<penberg@cs.helsinki.fi> and dated Wed Jun 10 18:50:32 2009 +0300.

The fault occurred because when CONFIG_SLUB_DEBUG was set, many of the
memory allocations for wireless buffers were increased from O(0) to
O(1) causing memory fragmentation, and eventually there were no
remaining O(1) fragments. This problem is unlikely to affect most
users as none of the distos turn on the above debug option.

This bug should be marked "closed with patch".

Larry

