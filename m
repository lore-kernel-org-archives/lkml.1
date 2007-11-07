Return-Path: <linux-kernel-owner+w=401wt.eu-S1759890AbXKGXMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890AbXKGXMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbXKGXMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:12:41 -0500
Received: from mail.davidb.org ([66.93.32.219]:36859 "EHLO mail.davidb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbXKGXMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:12:40 -0500
X-Greylist: delayed 1517 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2007 18:12:40 EST
Date: Wed, 7 Nov 2007 14:47:22 -0800
From: David Brown <lkml@davidb.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: compat_sys_times() bogus until jiffies >= 0.
Message-ID: <20071107224722.GA20204@old.davidb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

compat_sys_times() has bogus return until jiffies is >= 0.  I discovered
this running LTP within 5 minutes of booting.

The return result

	return compat_jiffies_to_clock_t(jiffies);

will return '-1' to user space and set the negated clock_t value to errno.

I'm not sure what the correct fix for this is.  I can come up with a patch
if anyone has ideas on how to fix it.

At minimum, perhaps it should return a sane errno value.

Thanks,
David Brown
