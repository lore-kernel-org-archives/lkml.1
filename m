Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZF2Qvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZF2Qvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZF2Qv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:51:27 -0400
Received: from fmailhost03.isp.att.net ([204.127.217.103]:53713 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZF2Qv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:51:27 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A48F114.1010702@lwfinger.net>
Date: Mon, 29 Jun 2009 11:51:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.fNH.4kASKB@chimera>
In-Reply-To: <5Hhc7UkUKEO.A.fNH.4kASKB@chimera>
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
> Date		: 2009-04-29 21:01 (61 days old)
> References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
> 		  http://lkml.org/lkml/2009/6/7/136
> Handled-By	: Johannes Berg <johannes@sipsolutions.net>

The cause of these failures has been determined. The wireless
subsystem frequently requests buffers of size 4096, but when SLUB
debugging is enabled and the debug info is added, the request becomes
of order 1 and memory becomes fragmented.

A controversial "fix" in which SLUB debugging was disabled for
allocations where adding such debugging info would increase the order
was discussed and tried. With a quick look at the commit list for
Linus's tree, I don't see that such a patch is available, but I will
be corrected if I missed it.

Larry
