Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbXBWW67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbXBWW67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 17:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXBWW67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 17:58:59 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:19937 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbXBWW67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 17:58:59 -0500
Date: Fri, 23 Feb 2007 14:58:47 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: mincore returning -ENOMEM instead of -EFAULT
Message-ID: <20070223225847.GL7920@ca-server1.us.oracle.com>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
	Your fix in commit 2f77d107050abc14bc393b34bdb7b91cf670c250
modifies sys_mincore() to return -ENOMEM instead of -EFAULT on a totally
bogus address.  Was this intentional, or is it something that should be
fixed up?

-       /* check the output buffer whilst holding the lock */
-       error = -EFAULT;
-       down_read(&current->mm->mmap_sem);
+       /* ..and we need to be passed a valid user-space range */
+       if (!access_ok(VERIFY_READ, (void __user *) start, len))
+               return -ENOMEM;

Joel

-- 

"Nobody loves me,
 Nobody seems to care.
 Troubles and worries, people,
 You know I've had my share."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
