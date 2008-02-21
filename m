Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYBUOqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYBUOqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 09:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYBUOqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 09:46:30 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:19672 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbYBUOq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 09:46:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pR3jAvQzroGvD4rTkluez12ZNH+6CISEYEA/TL9AH7of7BF3xs/bZFjV5stP6p6oLIsl2zWRu3bSOkw1RmNd/E3zHpB5FdF7Hf1/9WcsGKoW1mz8pKW5Jw25/J7cFAuOddIT0chXxkQToLI309w5oZTlqRG/+4QE5RCKMUt96QQ=
Message-ID: <2f11576a0802210646u77409690me940717fac746315@mail.gmail.com>
Date: Thu, 21 Feb 2008 23:46:25 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller in Kconfig
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "John Stoffel" <john@stoffel.org>, "Andi Kleen" <andi@firstfloor.org>,
       akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080220185104.GA30416@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080220122338.GA4352@basil.nowhere.org>
	 <47BC2275.4060900@linux.vnet.ibm.com>
	 <18364.16552.455371.242369@stoffel.org>
	 <47BC4554.10304@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.0802201647060.26109@fbirervta.pbzchgretzou.qr>
	 <20080220181911.GA4760@ucw.cz>
	 <Pine.LNX.4.64.0802201927440.26109@fbirervta.pbzchgretzou.qr>
	 <20080220185104.GA30416@elf.ucw.cz>
X-Google-Sender-Auth: d017e8cd1ec2a1ae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>  > >> For ordinary desktop people, memory controller is what developers
>  > >> know as MMU or sometimes even some other mysterious piece of silicon
>  > >> inside the heavy box.
>  > >
>  > >Actually I'd guess 'memory controller' == 'DRAM controller' == part of
>  > >northbridge that talks to DRAM.
>  >
>  > Yeah that must have been it when Windows says it found a new controller
>  > after changing the mainboard underneath.
>
>  Just for fun... this option really has to be renamed:

I think one reason of many people easy confusion is caused by bad menu
hierarchy.
I popose mem-cgroup move to child of cgroup and resource counter
(= obey denend on).

if you don't mind, please try to following patch.
may be, looks good than before.

---
 init/Kconfig |   52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

Index: b/init/Kconfig
===================================================================
--- a/init/Kconfig	2008-02-17 16:44:46.000000000 +0900
+++ b/init/Kconfig	2008-02-21 23:33:51.000000000 +0900
@@ -311,6 +311,32 @@ config CPUSETS

 	  Say N if unsure.

+config PROC_PID_CPUSET
+	bool "Include legacy /proc/<pid>/cpuset file"
+	depends on CPUSETS
+	default y
+
+config CGROUP_CPUACCT
+	bool "Simple CPU accounting cgroup subsystem"
+	depends on CGROUPS
+	help
+	  Provides a simple Resource Controller for monitoring the
+	  total CPU consumed by the tasks in a cgroup
+
+config RESOURCE_COUNTERS
+	bool "Resource counters"
+	help
+	  This option enables controller independent resource accounting
+          infrastructure that works with cgroups
+	depends on CGROUPS
+
+config CGROUP_MEM_CONT
+	bool "Memory controller for cgroups"
+	depends on CGROUPS && RESOURCE_COUNTERS
+	help
+	  Provides a memory controller that manages both page cache and
+	  RSS memory.
+
 config GROUP_SCHED
 	bool "Group CPU scheduler"
 	default y
@@ -352,20 +378,6 @@ config CGROUP_SCHED

 endchoice

-config CGROUP_CPUACCT
-	bool "Simple CPU accounting cgroup subsystem"
-	depends on CGROUPS
-	help
-	  Provides a simple Resource Controller for monitoring the
-	  total CPU consumed by the tasks in a cgroup
-
-config RESOURCE_COUNTERS
-	bool "Resource counters"
-	help
-	  This option enables controller independent resource accounting
-          infrastructure that works with cgroups
-	depends on CGROUPS
-
 config SYSFS_DEPRECATED
 	bool "Create deprecated sysfs files"
 	depends on SYSFS
@@ -387,18 +399,6 @@ config SYSFS_DEPRECATED
 	  If you are using a distro that was released in 2006 or later,
 	  it should be safe to say N here.

-config CGROUP_MEM_CONT
-	bool "Memory controller for cgroups"
-	depends on CGROUPS && RESOURCE_COUNTERS
-	help
-	  Provides a memory controller that manages both page cache and
-	  RSS memory.
-
-config PROC_PID_CPUSET
-	bool "Include legacy /proc/<pid>/cpuset file"
-	depends on CPUSETS
-	default y
-
 config RELAY
 	bool "Kernel->user space relay support (formerly relayfs)"
 	help
