Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbXCUWyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbXCUWyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXCUWyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:54:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:50189 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbXCUWyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Zb/0bQvJ4q03RW+A1bEkJTn+/kNNxwDD9nWEkLaV7mPIApzEJeHlhSRFuF6/e1vNk+sU4VLV+xeXtDdWGu1SlkcrxcnFbEqv7Cdq0uiOzhbSVP0z6Y7icqTuc4P+BmeMBOjwLCYNMcE69te/eOQ8x3zOxSdMR/mhwLDnxmmrTeg=
Subject: 2.6.21-rc suspend regression
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= RISS <frederic.riss@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: robert.moore@intel.com, "len.brown" <len.brown@intel.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 23:54:04 +0100
Message-Id: <1174517644.5633.31.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My MacMini (Intel Core Duo, EFI mode) doesn't come out of suspend to ram
with current git. This was working great with 2.6.20. A long bisection
phase[1] brought me to that old commit: 

Commit c5a7156959e89b32260ad6072bbf5077bcdfbeee
Author: Bob Moore <robert.moore@intel.com>  2007-02-02 17:48:19
Committer: Len Brown <len.brown@intel.com>  2007-02-03 03:14:22

    ACPICA: Disable all wake GPEs after first one recieved
    
    Change for GPE support: when a wake GPE is
    received, now all wake GPEs are immediately disabled to
    prevent the waking GPE from firing again, and to prevent
    other wake GPEs from interrupting the wake process.
    
    Signed-off-by: Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>


This commit prevents the box to come out of sleep. Unfortunately, simply
reverting from current master produces a conflict. If I resolve the
conflict by hand the kernel won't come out of sleep either :-( 

Looking at Adrian's regression lists, it seems a lot of other things
could produce the failures to resume... but that's a starting point. Do
the ACPI guys have an idea how this patch breaks my system?

I'll happily provide more info if needed.

Fred.

[1]: The ACPICA merge is based on 2.6.20-rc7 and not 2.6.20, thus I had
to bisect it by cherry-picking 40c373cc3af9720d1cec0e32c3da26b1d220a95b
(which is necessary to suspend the Mini in EFI mode) at each iteration.
This added to the fact that the ACPI merge bisection broke the build at
one point made the whole process a bit more painful that it need be.


