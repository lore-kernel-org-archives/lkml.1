Return-Path: <linux-kernel-owner+w=401wt.eu-S1751939AbZHZQWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbZHZQWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZHZQWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:22:46 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:49313 "EHLO lvk.cs.msu.su"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbZHZQWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:22:45 -0400
X-Greylist: delayed 1234 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 12:22:45 EDT
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: linux-kernel@vger.kernel.org
Subject: Suspend one thread and resume another in one system call ?
Date: Wed, 26 Aug 2009 20:02:05 +0400
User-Agent: KMail/1.9.9
Cc: Stas Bezzubtsev <stas@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908262002.06209@zigzag.lvk.cs.msu.su>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Consider a situation when:
- there is a set of threads,
- only one of those should be allowed to work at a time,
- there are "switch moments" when one thread should suspend, and other 
(known) resume.

"Classic" solutions like have each thread sleeping on a semaphore, and 
making switch operation "sem_post(next_sem); sem_wait(my_sem)" cause two 
syscalls per switch.

Could anyone suggest a solution with only one kernel entry per switch - 
running thread enters kernel and is de-scheduled, new thread resumes and 
leaves kernel?

Nikita

P.S.
Since there are other threads in the same application working in the 
parallel with the mentioned "exclusive set", user-space solutions like 
libpth are not interesting.
