Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbZCSNyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbZCSNyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZCSNyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:54:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbZCSNyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:54:01 -0400
Date: Thu, 19 Mar 2009 09:52:47 -0400 (EDT)
From: Miloslav Trmac <mitr@redhat.com>
To: viro <viro@zeniv.linux.org.uk>
Cc: Steve Grubb <sgrubb@redhat.com>, Eric Paris <eparis@redhat.com>,
       akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1887464454.1703501237470767793.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <573973171.1703051237470609326.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: Fwd: [patch for 2.6.27? 1/1] audit: ignore terminating NUL in
 AUDIT_USER_TTY messages
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_55554_157401073.1237470767792"
X-Originating-IP: [10.5.5.72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_55554_157401073.1237470767792
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,
this appears to have been lost somewhere...
    Mirek
------=_Part_55554_157401073.1237470767792
Content-Type: message/rfc822
Content-Disposition: attachment

Return-Path: akpm@linux-foundation.org
Received: from zmta01.collab.prod.int.phx2.redhat.com (LHLO
 zmta01.collab.prod.int.phx2.redhat.com) (10.5.5.31) by
 mail02.corp.redhat.com with LMTP; Mon, 22 Sep 2008 17:06:23 -0400 (EDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zmta01.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 03ECB904B0;
	Mon, 22 Sep 2008 17:06:23 -0400 (EDT)
Received: from zmta01.collab.prod.int.phx2.redhat.com ([127.0.0.1])
	by localhost (zmta01.collab.prod.int.phx2.redhat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BOWPPQbjMo3H; Mon, 22 Sep 2008 17:06:22 -0400 (EDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by zmta01.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id D9FBA90496;
	Mon, 22 Sep 2008 17:06:22 -0400 (EDT)
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8ML6KJ3001850;
	Mon, 22 Sep 2008 17:06:21 -0400
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8ML64v6001443;
	Mon, 22 Sep 2008 17:06:05 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8ML5XaL014107
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
	Mon, 22 Sep 2008 14:05:34 -0700
Received: from localhost.localdomain (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8ML5XGb029625;
	Mon, 22 Sep 2008 14:05:33 -0700
Message-Id: <200809222105.m8ML5XGb029625@imap1.linux-foundation.org>
Subject: [patch for 2.6.27? 1/1] audit: ignore terminating NUL in AUDIT_USER_TTY messages
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, mitr@redhat.com, eparis@redhat.com,
        sgrubb@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 22 Sep 2008 14:05:33 -0700
X-Spam-Status: No, hits=-3.358 required=5 tests=AWL,BAYES_00,OSDL_HEADER_SUBJECT_BRACKETED
X-Spam-Checker-Version: SpamAssassin 3.2.4-osdl_revision__1.47__
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.58 on 172.16.27.26
X-Scanned-By: MIMEDefang 2.63 on 172.16.48.32
X-Scanned-By: MIMEDefang 2.63 on 140.211.169.13
X-RedHat-Spam-Score: -1.588 

From: Miloslav Trmac <mitr@redhat.com>

AUDIT_USER_TTY, like all other messages sent from user-space, is sent
NUL-terminated.  Unlike other user-space audit messages, which come only
from trusted sources, AUDIT_USER_TTY messages are processed using
audit_log_n_untrustedstring().

This patch modifies AUDIT_USER_TTY handling to ignore the trailing NUL
and use the "quoted_string" representation of the message if possible.

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Steve Grubb <sgrubb@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/audit.c~audit-ignore-terminating-nul-in-audit_user_tty-messages kernel/audit.c
--- a/kernel/audit.c~audit-ignore-terminating-nul-in-audit_user_tty-messages
+++ a/kernel/audit.c
@@ -763,6 +763,9 @@ static int audit_receive_msg(struct sk_b
 
 				audit_log_format(ab, " msg=");
 				size = nlmsg_len(nlh);
+				if (size > 0 &&
+				    ((unsigned char *)data)[size - 1] == '\0')
+					size--;
 				audit_log_n_untrustedstring(ab, data, size);
 			}
 			audit_set_pid(ab, pid);
_

------=_Part_55554_157401073.1237470767792--
