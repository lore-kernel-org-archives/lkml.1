Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbYKTSUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbYKTSUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 13:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYKTSUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 13:20:23 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:37773 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbYKTSUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 13:20:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=UslGFLK6ZM11U1PeFzppsms42G+ZVMpzjviwyOz3JZqzsRhjhJj8eNeRHcfYxH/etn
         EHkun4UVYAgCFJgGhPF0qzQ0KLtYEM1uAlGxI+iJ3MMBqQnKo6eWsT+fRPWVWyE1N3y5
         9VXBTK8TKqJWhlTwcaiRhbsv+obWGFguXUsW0=
Message-ID: <4925AA56.9030409@gmail.com>
Date: Thu, 20 Nov 2008 13:20:06 -0500
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
CC: Pavel Emelyanov <xemul@openvz.org>, David Miller <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       adobriyan@gmail.com, Patrick McHardy <kaber@trash.net>, den@openvz.org,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-net@vger.kernel.org
Subject: CLONE_NEWNET documentation
References: <492489D1.5080502@gmail.com>
In-Reply-To: <492489D1.5080502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on my reading of some of the kernel source, various
documentation that I've now read, and comments I received
from people to my earlier mail ("Current state of Network
Namespaces (NETNS, CLONE_NEWNET)?"), I've written the patch
below to document the CLONE_NEWNET clone(2) flag.
Fixes and suggestions for improvements welcome.

Cheers,

Michael

   CLONE_NEWNET (since Linux 2.6.24)
      (The  implementation  of this flag is not yet com-
      plete, but probably will  be  mostly  complete  by
      about Linux 2.6.28.)

      If CLONE_NEWNET is set, then create the process in
      a new network namespace.  If this flag is not set,
      then  (as with fork(2)), the process is created in
      the same network namespace as the calling process.
      This  flag  is  intended for the implementation of
      containers.

      A network namespace provides an isolated  view  of
      the  networking  stack (network device interfaces,
      IPv4 and IPv6 protocol stacks, IP routing  tables,
      firewall  rules,  the /proc/net and /sys/class/net
      directory trees, sockets, etc.).  A physical  net-
      work device can live in exactly one network names-
      pace.  A virtual network device ("veth") pair pro-
      vides  a pipe-like abstraction that can be used to
      create tunnels between network namespaces, and can
      be  used  to create a bridge to a physical network
      device in another namespace.

      Use of this flag  requires:  a  kernel  configured
      with the CONFIG_NET_NS option and that the process
      be privileged (CAP_SYS_ADMIN).

--- a/man2/clone.2
+++ b/man2/clone.2
@@ -286,10 +285,41 @@ and
 configuration options and that the process be privileged
 .RB ( CAP_SYS_ADMIN ).
 This flag can't be specified in conjunction with
 .BR CLONE_SYSVSEM .
 .TP
+.BR CLONE_NEWNET " (since Linux 2.6.24)"
+(The implementation of this flag is not yet complete,
+but probably will be mostly complete by about Linux 2.6.28.)
+
+If
+.B CLONE_NEWNET
+is set, then create the process in a new network namespace.
+If this flag is not set, then (as with
+.BR fork (2)),
+the process is created in the same network namespace as
+the calling process.
+This flag is intended for the implementation of containers.
+
+A network namespace provides an isolated view of the networking stack
+(network device interfaces, IPv4 and IPv6 protocol stacks,
+IP routing tables, firewall rules, the
+.I /proc/net
+and
+.I /sys/class/net
+directory trees, sockets, etc.).
+A physical network device can live in exactly one
+network namespace.
+A virtual network device ("veth") pair provides a pipe-like abstraction
+that can be used to create tunnels between network namespaces,
+and can be used to create a bridge to a physical network device
+in another namespace.
+
+Use of this flag requires: a kernel configured with the
+.B CONFIG_NET_NS
+option and that the process be privileged
+.RB ( CAP_SYS_ADMIN ).
+.TP
 .BR CLONE_NEWNS " (since Linux 2.4.19)"
 Start the child in a new mount namespace.

 Every process lives in a mount namespace.
 The
@@ -822,10 +852,18 @@ but the kernel was not configured with the
 and
 .BR CONFIG_IPC_NS
 options.
 .TP
 .B EINVAL
+.BR CLONE_NEWNET
+was specified in
+.IR flags ,
+but the kernel was not configured with the
+.B CONFIG_NET_NS
+option.
+.TP
+.B EINVAL
 .BR CLONE_NEWPID
 was specified in
 .IR flags ,
 but the kernel was not configured with the
 .B CONFIG_PID_NS
@@ -844,10 +882,11 @@ Cannot allocate sufficient memory to allocate a task structure for the
 child, or to copy those parts of the caller's context that need to be
 copied.
 .TP
 .B EPERM
 .BR CLONE_NEWIPC ,
+.BR CLONE_NEWNET ,
 .BR CLONE_NEWNS ,
 .BR CLONE_NEWPID ,
 or
 .BR CLONE_NEWUTS
 was specified by a non-root process (process without \fBCAP_SYS_ADMIN\fP).
