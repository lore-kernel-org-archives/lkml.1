Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbYK0HMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbYK0HMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 02:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYK0HMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 02:12:47 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35694 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYK0HMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 02:12:46 -0500
Message-Id: <20081127070806.626288939@bull.net>
References: <20081127070720.954560982@bull.net>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 08:07:21 +0100
From: Nadia.Derbey@bull.net
To: mtk.manpages@gmail.com
Cc: serue@us.ibm.com, sukadev@us.ibm.com, xemul@openvz.org, kir@openvz.org,
       linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net
Subject: signal handling description for Michaels CLONE_NEWPID man page
Content-Disposition: inline; filename=pidns_signals.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

Here is the proposal for a description of signals handling in pid
namespaces.

This applies on top of your CLONE_NEWPID patch.

Regards,
Nadia

---
 man2/clone.2 |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

Index: man-pages-3.13/man2/clone.2
===================================================================
--- man-pages-3.13.orig/man2/clone.2	2008-11-24 09:34:30.000000000 +0100
+++ man-pages-3.13/man2/clone.2	2008-11-27 09:17:53.000000000 +0100
@@ -226,6 +226,29 @@ configuration option and requires that t
 .RB (CAP_SYS_ADMIN ).
 This flag can't be specified in conjunction with
 .BR CLONE_THREAD .
+
+.BR "Signals handling:"
+just like all the system calls that address a PID, signals can only be sent
+to a process whose PID belongs to the same namespace as the caller.
+
+There are ways signals can be sent across namespaces boundaries such that
+the sender does not have a valid pid in the receiver's pid namespace.
+In such cases, the sender pid will be seen by the receiver as a 0 value
+(this has an impact, for example, on the
+.BR siginfo_t
+structure contents - NOTE, this is still under development).
+
+The "init" process of a PID namespace has a particular status, since it
+is known both by its children as PID 1 and by its father's PID namespace
+as any other PID. Thus, the "init" process of a PID namespace can be sent
+any signal by a process that belongs to its ancestor's PID namespace (given
+that the sender has the appropriate permission). But the only signals that
+can be sent to the "init" process of a PID namespace from its own namespace
+are those for which it has explicitly installed signal handlers.
+More precisely, signals are sent successfully (i.e
+.BR kill (2)
+will not fail), but the "init" process will silently ignore unhandled signals.
+
 .TP
 .BR CLONE_PARENT " (since Linux 2.3.12)"
 If

-- 
