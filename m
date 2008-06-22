Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYFWIC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYFWIC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYFWICF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:02:05 -0400
Received: from mail.jambit.com ([62.245.207.83]:55856 "EHLO mail.jambit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbYFWICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:02:03 -0400
X-Greylist: delayed 1645 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2008 04:02:03 EDT
Message-ID: <485E002B.5010101@gmail.com>
Date: Sun, 22 Jun 2008 09:32:59 +0200
From: Michael Kerrisk <mtk.manpages@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Roman Zippel <zippel@linux-m68k.org>, lkml <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch] ADJ_OFFSET_SS_READ and capabilities
References: <485DF41E.9020909@gmail.com>
In-Reply-To: <485DF41E.9020909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman, John,

ADJ_OFFSET_SS_READ is a read-only operation.  Therefore, it seems
reasonable not to require any capability (as is the case when 'modes'
is zero.  See the patch below.  Does this change seem reasonable?

Cheers,

Michael

--- linux-2.6.26-rc5/kernel/time/ntp.c	2008-06-13 11:16:51.000000000 +0200
+++ linux-2.6.26-rc5-p/kernel/time/ntp.c	2008-06-22 07:31:43.000000000 +0200
@@ -281,7 +281,8 @@
  	int result;

  	/* In order to modify anything, you gotta be super-user! */
-	if (txc->modes && !capable(CAP_SYS_TIME))
+	if (txc->modes && txc->modes != ADJ_OFFSET_SS_READ &&
+	    !capable(CAP_SYS_TIME))
  		return -EPERM;

  	/* Now we validate the data before disabling interrupts */


