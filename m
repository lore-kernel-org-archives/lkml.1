Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbYHLN1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbYHLN1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYHLN1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:27:37 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:16338 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYHLN1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:27:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding:from;
        b=HWb9lbEiM8ZHuSTQVowjIoXUN0vnnragUTiw773fxIApDFKH4EVV/6hCCopdoGboRC
         U7Jm+7PIsHwzjySgc7cHJsaeMKU4g2fIdxNn6nfkBT+g/AMxmT6A9t8OjA44vWvUjYtS
         ckyAB1rAPOtzrS5VTn+kIGXmKPb9uBHj36yFQ=
Message-ID: <48A18ED4.5030406@gmail.com>
Date: Tue, 12 Aug 2008 15:23:32 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-page-3.07 is released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-3.07.

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

This release is now available for download at:

     http://www.kernel.org/pub/linux/docs/man-pages
     or ftp://ftp.kernel.org/pub/linux/docs/man-pages

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(an overview of the changes in this release is blogged at
http://linux-man-pages.blogspot.com/2008/08/man-pages-307-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

An abridged version of the changes in this release that may be of
interest to readers of this list is provided below.

Cheers,

Michael


==================== Changes in man-pages-3.07 ====================

New and rewritten pages
-----------------------

move_pages.2
     Christoph Lameter, various edits and improvements by mtk
         Documentation of the move_pages() system call.
         This page was formerly part of the numactl package, but really
         belongs in man-pages (since it describes a kernel interface).

clock_getcpuclockid.3
     mtk
         New page documenting the clock_getcpuclockid() library function,
         available since glibc 2.2.

udplite.7
     Gerrit Renker
         Document the Linux implementation of the UDP-Lite protocol,
         new in Linux 2.6.20.


Newly documented interfaces in existing pages
---------------------------------------------

proc.5
     Christoph Lameter, minor edits and improvements by mtk
         Documentation of the /proc/PID/numa_maps file.
         This material was formerly the numa_maps.5 page in the numactl
         package, but really belongs in man-pages (since it describes
         a kernel interface).


Global changes
--------------

connect.2
socket.2
rtnetlink.3
arp.7
ddp.7
ip.7
ipv6.7
netlink.7
packet.7
raw.7
rtnetlink.7
socket.7
tcp.7
udp.7
unix.7
x25.7
     mtk
         s/PF_/AF_/ for socket family constants.  Reasons: the AF_ and
         PF_ constants have always had the same values; there never has
         been a protocol family that had more than one address family,
         and POSIX.1-2001 only specifies the AF_* constants.


Changes to individual pages
---------------------------

get_mempolicy.2
     Lee Schermerhorn
         Misc cleanup of get_mempolicy(2):
         + mention that any mode flags will be saved with mode.
           I don't bother to document mode flags here because we
           already have a pointer to set_mempolicy(2) for more info
           on memory policy.  mode flags are discussed there.
         + remove some old, obsolete [IMO] NOTES and 'roff comments.
     Lee Schermerhorn
         Update the get_mempolicy(2) man page to add in the description of
         the MPOL_F_MEMS_ALLOWED flag, added in 2.6.23.
     mtk
         Document additional EINVAL error that occurs is MPOL_F_MEMS_ALLOWED
         is specified with either MPOL_F_ADDR or MPOL_F_NODE.

mbind.2
     Lee Schermerhorn
         Fix error conditions, now that the kernel silently ignores
         nodes outside the task's cpuset, as long as one valid node
         remains.

         Now that cpuset man page exists, we can refer to it.  Remove
         stale comment regarding lack thereof.
     Lee Schermerhorn
         Add brief discussion of mode flags.
     Lee Schermerhorn
         Attempt to clarify discussion of MPOL_DEFAULT.
     mtk
         Fix URI reference for libnuma.

set_mempolicy.2
     Lee Schermerhorn
         Fix up the error return for nodemask containing nodes disallowed by
         the process' current cpuset.  Disallowed nodes are now silently ignored,
         as long as the nodemask contains at least one node that is on-line,
         allowed by the process' cpuset and has memory.

         Now that we have a cpuset man page, we can refer to cpusets directly
         in the man page text.

     Lee Schermerhorn
         Another attempt to rationalize description of MPOL_DEFAULT.

         Since ~2.6.25, the system default memory policy is "local allocation".
         MPOL_DEFAULT itself is a request to remove any non-default policy and
         "fall back" to the surrounding context.  Try to say that without delving
         into implementation details.

     Lee Schermerhorn
         Add discussion of mempolicy mode flags to set_mempolicy(2).
         This adds another reason for EINVAL.

