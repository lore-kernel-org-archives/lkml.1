Return-Path: <linux-kernel-owner+w=401wt.eu-S932637AbYETO2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbYETO2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbYETO23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:28:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:47818 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbYETO22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=e3qhkuR1rb9QpObUDuTyUyl3wHLJ3kBERjanMZ2W01m+mQBU5Kidc6VPF3RGhqu5GYqJXROvgzcj2++5nZ6NtFCzWZIVSgBt0QGSk3CWHNynPUduXXykr1y0hJMxDxyZ8g5zmqYbLe7E8hbu2lQFQv4G/QB5IkEfbbZpJqdISQw=
Message-ID: <cfd18e0f0805200728j1f38d90s1f6355b71e2d76@mail.gmail.com>
Date: Tue, 20 May 2008 16:28:27 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: Nadia.Derbey@bull.net
Subject: Re: [PATCH 1/8] Scaling msgmni to the amount of lowmem
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-mm@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nadia,

Regarding your:

[PATCH 1/8] Scaling msgmni to the amount of lowmem
http://article.gmane.org/gmane.linux.kernel/637849/
which I see has made its way in 2.6.26-rc

Your patch has the following change:

-#define MSGPOOL (MSGMNI*MSGMNB/1024)  /* size in kilobytes of message pool */
+#define MSGPOOL (MSGMNI * MSGMNB) /* size in bytes of message pool */

Since this constitutes a kernel-userland interface change, so please
do CC me, so that I can change the man pages if needed.

The man page (http://www.kernel.org/doc/man-pages/online/pages/man2/msgctl.2.html)
does indeed say that msgpool is "unused".  But that meant "unused by
the kernel" (sorry -- I probably should have worded that text better).
 And, as you spotted, the page also wrongly said the value is in
bytes.

However, making this change affects the ABI.  A userspace application
that was previously using msgctl(IPC_INFO) to retrieve the msgpool
field will be affected by the factor-of-1024 change.  I strongly
suspect that there no such applications, or certainly none that care
(since this value is unused by the kernel).  But was there a reason
for making this change, aside from the fact that the code and the man
page didn't agree?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
