Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYKSTMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYKSTMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbYKSTMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:12:08 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:30340 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbYKSTMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:12:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=RMEpW830r/bUB78EuNsWbwktj8q0NvoBGE2hHghpVReH6wMwuQL3oiI+j7oCvzgNZm
         ys15nxjDFajpgLEHZhHlCQ8oljmx22HI/8SuLhw+eROMzCftPAHmL5V+oprkzbbikn6Y
         Jx8sIhP8AOu7Nac5S0Mm8gAuZPfswCJA6YB7k=
Message-ID: <492464F8.8070101@gmail.com>
Date: Wed, 19 Nov 2008 14:11:52 -0500
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       Kirill Korotaev <dev@openvz.org>, Herbert Poetzl <herbert@13thfloor.at>,
       Andrey Savochkin <saw@sw.ru>,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: CLONE_NEWUTS documentation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge, Eric,

Below is a patch to document the CLONE_NEWUTS flag that was
added in 2.6.19.

Could you please review and let me know of improvements
or inaccuracies?

By the way, does anyone know where the UTS name in the uname()
API comes from? My best guess is that it's from Unix Timesharing
System, but I don't know this for sure.

Cheers,

Michael

diff --git a/man2/clone.2 b/man2/clone.2
index 7212332..80f9caf 100644
--- a/man2/clone.2
+++ b/man2/clone.2
@@ -341,6 +340,33 @@ configuration option and that the process be privileged
 This flag can't be specified in conjunction with
 .BR CLONE_THREAD .
 .TP
+.BR CLONE_NEWUTS " (since Linux 2.6.19)"
+If
+.B CLONE_NEWUTS
+is set, then create the process in a new UTS namespace.
+If this flag is not set, then (as with
+.BR fork (2)),
+the process is created in the same UTS namespace as
+the calling process.
+This flag is intended for the implementation of control groups.
+
+A UTS namespace is the set of identifiers returned by
+.BR uname (2);
+among these, the domain name and the host name can be modified by
+.BR setdomainname (2)
+and
+.BR
+.BR sethostname (2),
+respectively.
+Changes made to these identifiers in one UTS namespace
+are visible to other processes in the same namespace,
+but are not visible to processes in other UTS namespaces.
+
+Use of this flag requires: a kernel configured with the
+.B CONFIG_UTS_NS
+configuration option and that the process be privileged
+.RB ( CAP_SYS_ADMIN ).
+.TP
 .BR CLONE_PARENT " (since Linux 2.3.12)"
 If
 .B CLONE_PARENT
@@ -723,15 +749,24 @@ but the kernel was not configured with the
 .B CONFIG_PID_NS
 option.
 .TP
+.B EINVAL
+.BR CLONE_NEWUTS
+was specified in
+.IR flags ,
+but the kernel was not configured with the
+.B CONFIG_UTS
+option.
+.TP
 .B ENOMEM
 Cannot allocate sufficient memory to allocate a task structure for the
 child, or to copy those parts of the caller's context that need to be
 copied.
 .TP
 .B EPERM
-.B CLONE_NEWNS
+.BR CLONE_NEWNS ,
+.BR CLONE_NEWPID ,
 or
-.B CLONE_NEWPID
+.BR CLONE_NEWUTS
 was specified by a non-root process (process without \fBCAP_SYS_ADMIN\fP).
 .TP
 .B EPERM


