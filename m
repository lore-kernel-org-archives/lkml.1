Return-Path: <linux-kernel-owner+w=401wt.eu-S936383AbYBVAtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936383AbYBVAtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762151AbYBVAtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:49:08 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:55128 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1760199AbYBVAtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:49:06 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Fri, 22 Feb 2008 11:48:32 +1100
Message-ID: <20080222-114832-init-kconfig-1@tull.net>
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Serge Hallyn <serue@us.ibm.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: [PATCH 2.6.25-rc2 1/9] Kconfig: Improve init/Kconfig help descriptions part 1
References: <20080219140609.GA26619@tull.net>
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the help descriptions for clarity, accuracy and consistency.

The problems I can see with the supplied help descriptions fall into
these areas:

  - Uses arcane terminology which only kernel developers can understand

  - Inconsistently describes safe response (if unsure, ...)

  - References out-of-date external resources (404 error)

  - Description has not kept pace with recent kernel changes or standards

  - Poor grammar or layout.


My approach to improving the descriptions is to go through each option
checking the correctness of the description, validating any references
it makes, finding inconsistency with the rest of the kernel config,
and trying to improve the usefulness of the explanation. I want to
end up with:

  1 - Single sentence summary of what the option does

  2 - Explain terminology or situation if necessary and possible, linking
  to validated information sources (Documentation directory, manpages,
  scripts, URLs, Wikipedia)

  3 - Suggest safe answer for people who just don't know what to do.


Kernel config options affected:

  - EXPERIMENTAL
  - LOCALVERSION
  - LOCALVERSION_AUTO
  - SWAP
  - SYSVIPC
  - POSIX_MQUEUE
  - BSD_PROCESS_ACCT
  - BSD_PROCESS_ACCT_V3

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---
Try #3.

--- a/init/Kconfig	2008-02-20 09:34:48.000000000 +1100
+++ b/init/Kconfig	2008-02-20 09:35:08.000000000 +1100
@@ -20,33 +20,45 @@ menu "General setup"
 config EXPERIMENTAL
 	bool "Prompt for development and/or incomplete code/drivers"
 	---help---
-	  Some of the various things that Linux supports (such as network
-	  drivers, file systems, network protocols, etc.) can be in a state
-	  of development where the functionality, stability, or the level of
-	  testing is not yet high enough for general use. This is usually
-	  known as the "alpha-test" phase among developers. If a feature is
-	  currently in alpha-test, then the developers usually discourage
-	  uninformed widespread use of this feature by the general public to
-	  avoid "Why doesn't this work?" type mail messages. However, active
-	  testing and use of these systems is welcomed. Just be aware that it
-	  may not meet the normal level of reliability or it may fail to work
-	  in some special cases. Detailed bug reports from people familiar
-	  with the kernel internals are usually welcomed by the developers
-	  (before submitting bug reports, please read the documents
-	  <file:README>, <file:MAINTAINERS>, <file:REPORTING-BUGS>,
-	  <file:Documentation/BUG-HUNTING>, and
-	  <file:Documentation/oops-tracing.txt> in the kernel source).
+	  This option enables you to choose kernel configuration
+	  options labeled as EXPERIMENTAL.
+
+	  Some of the various things that Linux supports (such as
+	  network drivers, file systems, network protocols, etc.) can
+	  be in a state of development where the functionality,
+	  stability, or the level of testing is not yet high enough
+	  for general use. This is usually known as the "alpha-test"
+	  phase among developers.
+
+	  If a feature is currently in alpha-test, then the
+	  developers usually discourage uninformed widespread use of
+	  this feature by the general public to avoid "Why doesn't
+	  this work?" type email messages. However, active testing
+	  and use of these systems is welcomed. Just be aware that
+	  it may not meet the normal level of reliability or it
+	  may fail to work in some special cases.
+
+	  Detailed bug reports from people familiar with
+	  the kernel internals are usually welcomed by the
+	  developers. Before submitting bug reports, please
+	  read the documents <file:README>, <file:MAINTAINERS>,
+	  <file:REPORTING-BUGS>, <file:Documentation/BUG-HUNTING>,
+	  and <file:Documentation/oops-tracing.txt> in the kernel
+	  source.
 
 	  This option will also make obsoleted drivers available. These are
 	  drivers that have been replaced by something else, and/or are
 	  scheduled to be removed in a future kernel release.
 
-	  Unless you intend to help test and develop a feature or driver that
-	  falls into this category, or you have a situation that requires
-	  using these features, you should probably say N here, which will
-	  cause the configurator to present you with fewer choices. If
-	  you say Y here, you will be offered the choice of using features or
-	  drivers that are currently considered to be in the alpha-test phase.
+	  Unless you intend to help test and develop a feature or driver
+	  that falls into this category, or you have a situation that
+	  requires using these features, you should probably say N here,
+	  which will cause the configurator to present you with fewer
+	  choices. If you say Y here, you will be offered the choice of
+	  using features or drivers that are currently considered to be
+	  in the alpha-test phase.
+
+	  If unsure, say N.
 
 config BROKEN
 	bool
@@ -74,11 +86,18 @@ config LOCALVERSION
 	string "Local version - append to kernel release"
 	help
 	  Append an extra string to the end of your kernel version.
-	  This will show up when you type uname, for example.
-	  The string you set here will be appended after the contents of
-	  any files with a filename matching localversion* in your
-	  object and source tree, in that order.  Your total string can
-	  be a maximum of 64 characters.
+	  This will show up when you type "uname -r", for example.
+
+	  If you have any files with names matching "localversion*"
+	  in your object or source trees, then the contents of these
+	  files will be appended to your kernel version name.
+
+	  The strings are appended from the object tree files and
+	  then the source tree files, then any string specified
+	  by CONFIG_LOCALVERSION_AUTO below, and finally the value
+	  specified here.
+
+	  The maximum length of a kernel version name is 64 characters.
 
 config LOCALVERSION_AUTO
 	bool "Automatically append version information to the version string"
@@ -93,38 +112,47 @@ config LOCALVERSION_AUTO
 	  appended after any matching localversion* files, and after the value
 	  set in CONFIG_LOCALVERSION.
 
-	  (The actual string used here is the first eight characters produced
+	  The actual string used here is the first eight characters produced
 	  by running the command:
 
 	    $ git rev-parse --verify HEAD
 
-	  which is done within the script "scripts/setlocalversion".)
+	  which is done within the script "scripts/setlocalversion".
 
 config SWAP
 	bool "Support for paging of anonymous memory (swap)"
 	depends on MMU && BLOCK
 	default y
 	help
-	  This option allows you to choose whether you want to have support
-	  for so called swap devices or swap files in your kernel that are
-	  used to provide more virtual memory than the actual RAM present
-	  in your computer.  If unsure say Y.
+	  This option allows you to choose whether you want to have
+	  support for swap devices or swap files in your kernel.
+
+	  Swap is used to provide more virtual memory than the
+	  actual RAM present in your computer. This can improve
+	  performance by moving less frequently used blocks of
+	  memory onto disk, which frees it up for improved disk
+	  caching or active processes.
+
+	  If unsure, say Y.
 
 config SYSVIPC
 	bool "System V IPC"
 	---help---
-	  Inter Process Communication is a suite of library functions and
+	  Inter-Process Communication is a suite of library functions and
 	  system calls which let processes (running programs) synchronize and
 	  exchange information. It is generally considered to be a good thing,
-	  and some programs won't run unless you say Y here. In particular, if
-	  you want to run the DOS emulator dosemu under Linux (read the
-	  DOSEMU-HOWTO, available from <http://www.tldp.org/docs.html#howto>),
-	  you'll need to say Y here.
+	  and some programs won't run without it.
+
+	  In particular, if you want to run the DOS emulator dosemu
+	  under Linux, you'll need to say Y here. You can find out
+	  more about dosemu at <http://dosemu.sourceforge.net/>
 
 	  You can find documentation about IPC with "info ipc" and also in
 	  section 6.4 of the Linux Programmer's Guide, available from
 	  <http://www.tldp.org/guides.html>.
 
+	  If unsure, say Y.
+
 config SYSVIPC_SYSCTL
 	bool
 	depends on SYSVIPC
@@ -135,42 +163,69 @@ config POSIX_MQUEUE
 	bool "POSIX Message Queues"
 	depends on NET && EXPERIMENTAL
 	---help---
-	  POSIX variant of message queues is a part of IPC. In POSIX message
-	  queues every message has a priority which decides about succession
-	  of receiving it by a process. If you want to compile and run
-	  programs written e.g. for Solaris with use of its POSIX message
-	  queues (functions mq_*) say Y here.
-
-	  POSIX message queues are visible as a filesystem called 'mqueue'
-	  and can be mounted somewhere if you want to do filesystem
-	  operations on message queues.
+	  POSIX Message Queues is a type of Inter-Process Communication
+	  (IPC). It provides similar functionality to System V message
+	  queues, with a different Application Programming Interface (API).
+
+	  In POSIX Message Queues, every message has a priority which
+	  determines the order in which each message is delivered to a
+	  receiving process. See mq_overview(7) for details of the
+	  API (functions mq_*).
+
+	  When POSIX Message Queues are enabled, a directory appears
+	  called /proc/sys/fs/mqueue which can be used to tune kernel
+	  parameters. See mq_overview(7) for details.
+
+	  POSIX Message Queues can also be mounted as a filesystem
+	  called 'mqueue', for example: "mount -t mqueue none /mqueue".
 
 	  If unsure, say Y.
 
 config BSD_PROCESS_ACCT
 	bool "BSD Process Accounting"
 	help
-	  If you say Y here, a user level program will be able to instruct the
-	  kernel (via a special system call) to write process accounting
-	  information to a file: whenever a process exits, information about
-	  that process will be appended to the file by the kernel.  The
-	  information includes things such as creation time, owning user,
-	  command name, memory usage, controlling terminal etc. (the complete
-	  list is in the struct acct in <file:include/linux/acct.h>).  It is
-	  up to the user level program to do useful things with this
-	  information.  This is generally a good idea, so say Y.
+	  BSD Process Accounting enables the kernel to write process
+	  accounting information to a file to track system resources
+	  utilisation and some user actions.
+
+	  Whenever a process exits, information about that process
+	  will be appended to the file. This includes things such as
+	  creation time, owning user, command name, memory usage,
+	  controlling terminal, etc.
+
+	  See sa(1), accton(8) and acct(2) for more details, also
+	  <file:include/linux/acct.h> (struct acct) for the complete
+	  list of stored data.
+
+	  You probably only need this if you have multiple users and
+	  you want to monitor or account for their system usage, and
+	  fine-tune system performance through analysis of the logfile.
+
+	  If unsure, say N.
 
 config BSD_PROCESS_ACCT_V3
 	bool "BSD Process Accounting version 3 file format"
 	depends on BSD_PROCESS_ACCT
 	default n
 	help
-	  If you say Y here, the process accounting information is written
-	  in a new file format that also logs the process IDs of each
-	  process and it's parent. Note that this file format is incompatible
-	  with previous v0/v1/v2 file formats, so you will need updated tools
-	  for processing it. A preliminary version of these tools is available
-	  at <http://www.physik3.uni-rostock.de/tim/kernel/utils/acct/>.
+	  BSD Process Accounting enables the kernel to write process
+	  accounting information to a file to track system resources
+	  utilisation and some user actions.
+
+	  Version 3 is a new file format that also logs the process
+	  ID and process parent ID.
+
+	  Note that this file format is incompatible with previous
+	  v0/v1/v2 file formats, so you will need updated tools
+	  for processing it. One such tool is "bootchart", and
+	  the GNU "acct" package should be able to read the v3
+	  file format too.
+
+	  You probably only need this if you have multiple users and
+	  you want to monitor or account for their system usage, and
+	  fine-tune system performance through analysis of the logfile.
+
+	  If unsure, say N.
 
 config TASKSTATS
 	bool "Export task/process statistics through netlink (EXPERIMENTAL)"
