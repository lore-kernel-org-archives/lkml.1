Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYKSTMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYKSTMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYKSTMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:12:40 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:62364 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbYKSTMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:12:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=DzatzyAxuHamDlGzLmyDafC5tZIdypxfrDFZdT+SyuXebRvGW9bMq9/BmLhg5wfYxt
         AoXwGGQuWtXYLtRT6hFw0x17ucL2RpaWc+9grOWw0ZapNsgotvBTz7rgy5w9SeQNMZP8
         M9YIa+3q/UzTcN386swq0b+ReLGDpmcbAWc80=
Message-ID: <4924651C.4080909@gmail.com>
Date: Wed, 19 Nov 2008 14:12:28 -0500
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Kirill Korotaev <dev@openvz.org>, Pavel Emelianov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
CC: Cedric Le Goater <clg@fr.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org
Subject: CLONE_NEWIPC documentation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill, Pavel,

Below is a patch to document the CLONE_NEWIPC flag that was
added in 2.6.19.

Could you please review and let me know of improvements
or inaccuracies?

Cheers,

Michael

--- a/man2/clone.2
+++ b/man2/clone.2
@@ -225,6 +224,36 @@ Calls to
 .BR umask (2)
 performed later by one of the processes do not affect the other process.
 .TP
+.BR CLONE_NEWIPC " (since Linux 2.4.19)"
+If
+.B CLONE_NEWIPC
+is set, then create the process in a new IPC namespace.
+If this flag is not set, then (as with
+.BR fork (2)),
+the process is created in the same IPC namespace as
+the calling process.
+This flag is intended for the implementation of control groups.
+
+An IPC namespace consistes of the set of identifiers for
+System V IPC objects.
+(These objects are created using
+.BR msgctl (2),
+.BR semctl (2),
+and
+.BR shmctl (2)).
+Objects created in an IPC namespace are visible to other processes
+that are members of that namespace,
+but are not visible to processes in other IPC namespaces.
+
+Use of this flag requires: a kernel configured with the
+.B CONFIG_SYSVIPC
+and
+.B CONFIG_IPC_NS
+configuration options and that the process be privileged
+.RB ( CAP_SYS_ADMIN ).
+This flag can't be specified in conjunction with
+.BR CLONE_SYSVSEM .
+.TP
 .BR CLONE_NEWNS " (since Linux 2.4.19)"
 Start the child in a new namespace.

@@ -729,6 +758,14 @@ were specified in
 .TP
 .B EINVAL
 Both
+.B CLONE_NEWIPC
+and
+.B CLONE_SYSVSEM
+were specified in
+.IR flags .
+.TP
+.B EINVAL
+Both
 .BR CLONE_NEWPID
 and
 .BR CLONE_THREAD
@@ -742,6 +779,16 @@ when a zero value is specified for
 .IR child_stack .
 .TP
 .B EINVAL
+.BR CLONE_NEWIPC
+was specified in
+.IR flags ,
+but the kernel was not configured with the
+.B CONFIG_SYSVIPC
+and
+.BR CONFIG_IPC_NS
+options.
+.TP
+.B EINVAL
 .BR CLONE_NEWPID
 was specified in
 .IR flags ,
