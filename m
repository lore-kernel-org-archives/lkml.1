Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYFCF33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYFCF33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 01:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYFCF3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 01:29:20 -0400
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:51287 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYFCF3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 01:29:20 -0400
X-Greylist: delayed 664 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2008 01:29:20 EDT
Message-ID: <4844D414.7010402@freemail.hu>
Date: Tue, 03 Jun 2008 07:18:12 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [regression][bisected] ~90,000 wakeups as of 2.6.26-rc3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00a.mail.t-online.hu 32710; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there is a problem in 2.6.26-rc3 which was not there in case of
2.6.25: the CPU wakes up ~90,000 times per sec instead of ~60 per sec.

I also "git bisected" the problem, the result is:

6e908947b4995bc0e551a8257c586d5c3e428201 is first bad commit
commit 6e908947b4995bc0e551a8257c586d5c3e428201
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Mar 21 14:32:36 2008 +0100

    x86: fix ioapic bug again

    un-revert:

     commit 4960c9df1407c2723459c60ff13e6efe0c209c62
     Author: Thomas Gleixner <tglx@linutronix.de>
     Date:   Tue Jan 22 10:23:01 2008 +0100

         Revert "x86: fix NMI watchdog & 'stopped time' problem"

             This reverts commit d4d25deca49ec2527a634557bf5a6cf449f85deb.

    needs a proper fix though ...

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 02918f7e330d004e1dd4c6fbb340ba4e353916df
7f9969e324e5982ebf232bb9e5f5c27f208f977b M      arch


For more details please see: http://bugzilla.kernel.org/show_bug.cgi?id=9489

Regards,

	Márton Németh
