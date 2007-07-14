Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbXGNHlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbXGNHlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 03:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXGNHls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 03:41:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:33681 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751844AbXGNHlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 03:41:47 -0400
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Sat, 14 Jul 2007 09:41:45 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
Message-ID: <20070714074145.277260@gmx.net>
MIME-Version: 1.0
Subject: signalfd() semantics after execve()
To: Davide Libenzi <davidel@xmailserver.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19co5lnLEJcrzZEDo+5kyBhNQTxtssfAoKcwurWmr
 psT1Cw6XUdK8jJz8SQgg4hSpQT1fslBv/BBw== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: bhvqZioNeSEqRsf8EHUhSWV+IGRvbwA2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide, 

I'm working on the signalfd(2) man page, and I've come
acorss some puzzling behaviour...  

What are the intended semantics of a signalfd file descriptor
after an execve()?

As far as I can work out, after an execve() the file descriptor
is still available, but reads from it always return 0, even if:

a) there were signals pending before the execve().
   However, sigpending() shows the signal as pending,
   and the signal can be accepted using sigwaitinfo().

b) we generate a signal after the execve().
 
Is this intended behavior (the "orphaned sighand" condition
mentioned in the draft man page you sent me?)?  Is it a bug?

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

