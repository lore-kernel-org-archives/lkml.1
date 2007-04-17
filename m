Return-Path: <linux-kernel-owner+w=401wt.eu-S1751722AbXDQVh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbXDQVh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXDQVh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:37:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbXDQVh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:37:27 -0400
Date: Tue, 17 Apr 2007 17:37:16 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: luming.yu@intel.com, adaplas@pol.net, greg@kroah.com, len.brown@intel.com
Subject: drivers/video/output.c
Message-ID: <20070417213716.GB7284@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, luming.yu@intel.com,
	adaplas@pol.net, greg@kroah.com, len.brown@intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 2dec3ba8d872aa3ffbcdb8f6f8a2c0bcd44e9910 puzzles me.

git-bisect just fingered it as responsible for my "backlight doesn't turn on"
suspend/resume regression on the Thinkpad X60.  I think it's lying.

Why?  Because afaict, drivers/video/output.c is never compiled.
That commit adds the driver, but doesn't touch any Makefile, and I
don't see anything obvious in the follow-in commits that would 'enable' it.

Asides from git-bisect failing me again[1], what gives with this file?

	Dave

[1] bisecting suspend regressions _really_ sucks.  Each time I've tried this
I've found 2-3 different ways we regressed along the bisection, making it
hard to say "good" or "bad" when the answer is "bad, but broken differently"

-- 
http://www.codemonkey.org.uk
