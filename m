Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbYEMAG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbYEMAG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 20:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbYEMAGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 20:06:20 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:48352 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756031AbYEMAGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 20:06:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQEAM93KEhMROPA/2dsb2JhbACBU6pW
Date: Mon, 12 May 2008 20:06:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: mingo@redhat.com
Subject: System call audit
Message-ID: <20080513000617.GA26009@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:58:31 up 73 days, 19:09,  5 users,  load average: 0.40, 0.31,
	0.28
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

As I am looking into the system-wide system call tracing problem, I
start to wonder how auditsc deals with the fact that user-space could
concurrently change the content referred to by the __user pointers.

This would be the case for execve. If we create a program with two
thread; one is executing execve syscalls and the other thread would be
modifying the userspace string containing the name of the program to
execute. Since we have two copy_from_user, one in auditsc and one in the
real execve() function, the string passed to the OS could differ from
the string seen by auditsc.

Regards,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
