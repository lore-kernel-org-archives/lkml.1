Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbXLAJPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbXLAJPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 04:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbXLAJPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 04:15:36 -0500
Received: from neopsis.com ([213.239.204.14]:48125 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751019AbXLAJPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 04:15:35 -0500
Message-ID: <4752703B.10305@dbservice.com>
Date: Sun, 02 Dec 2007 09:43:39 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071130)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: WARNING: smp_call_function_single() and smp_call_function_mask()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-1.176,
	required 5, autolearn=spam, AWL -0.87, BAYES_00 -2.60,
	DATE_IN_FUTURE_12_24 2.19, RDNS_DYNAMIC 0.10)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: at arch/x86/kernel/smp_64.c:427 smp_call_function_single()
WARNING: at arch/x86/kernel/smp_64.c:397 smp_call_function_mask()

dmesg and config attached.

I'm getting about three of each at boot. I'm running:
commit e1cca7e8d484390169777b423a7fe46c7021fec1
Date:   Thu Nov 29 16:25:29 2007 -0800
which is the latest git as of yesterday plus a one (unrelated) debug
statement patch in usb uhci.

There was a similar bug report after 2.6.23-rc8-mm was released. Though
there seems to be a fundamental problem with how people use
smp_call_function*() [1]. And this can just as well be another
incarnation of it.

Is that easy enough to fix or do I need to bisect (it didn't happen in
2.6.24-rc3)?

tom

[1] http://kerneltrap.org/mailarchive/linux-kernel/2007/9/27/324310
