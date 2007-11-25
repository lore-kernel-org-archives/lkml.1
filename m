Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbXKYUjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbXKYUjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 15:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbXKYUj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 15:39:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35849 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370AbXKYUj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 15:39:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Update REPORTING-BUGS
Date: Sun, 25 Nov 2007 21:57:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711252157.10212.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The recent "kernel bugzilla is FPOS" thread made me think that it might be a
good idea to update REPORTING-BUGS, so that it's more "friendly" to people who
want to report a kernel bug for the first time.

The patch below does that, but it's more a means to spark a discussion than
anything else.

Comments are obviously welcome. :-)

Greetings,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Update REPORTING-BUGS to reflect the current common practice and to provide
inexperienced bug reporters with some more information.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 REPORTING-BUGS |  160 +++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 99 insertions(+), 61 deletions(-)

Index: linux-2.6/REPORTING-BUGS
===================================================================
--- linux-2.6.orig/REPORTING-BUGS
+++ linux-2.6/REPORTING-BUGS
@@ -1,64 +1,102 @@
-[Some of this is taken from Frohwalt Egerer's original linux-kernel FAQ]
-
-     What follows is a suggested procedure for reporting Linux bugs. You
-aren't obliged to use the bug reporting format, it is provided as a guide
-to the kind of information that can be useful to developers - no more.
-
-     If the failure includes an "OOPS:" type message in your log or on
-screen please read "Documentation/oops-tracing.txt" before posting your
-bug report. This explains what you should do with the "Oops" information
-to make it useful to the recipient.
-
-      Send the output to the maintainer of the kernel area that seems to
-be involved with the problem. Don't worry too much about getting the
-wrong person. If you are unsure send it to the person responsible for the
-code relevant to what you were doing. If it occurs repeatably try and
-describe how to recreate it. That is worth even more than the oops itself.
-The list of maintainers is in the MAINTAINERS file in this directory.
-
-      If it is a security bug, please copy the Security Contact listed
-in the MAINTAINERS file.  They can help coordinate bugfix and disclosure.
-See Documentation/SecurityBugs for more information.
-
-      If you are totally stumped as to whom to send the report, send it to
-linux-kernel@vger.kernel.org. (For more information on the linux-kernel
-mailing list see http://www.tux.org/lkml/).
-
-This is a suggested format for a bug report sent to the Linux kernel mailing
-list. Having a standardized bug report form makes it easier for you not to
-overlook things, and easier for the developers to find the pieces of
-information they're really interested in. Don't feel you have to follow it.
-
-      First run the ver_linux script included as scripts/ver_linux, which
-reports the version of some important subsystems.  Run this script with
-the command "sh scripts/ver_linux".
-
-Use that information to fill in all fields of the bug report form, and
-post it to the mailing list with a subject of "PROBLEM: <one line
-summary from [1.]>" for easy identification by the developers.
-
-[1.] One line summary of the problem:
-[2.] Full description of the problem/report:
-[3.] Keywords (i.e., modules, networking, kernel):
-[4.] Kernel information
-[4.1.] Kernel version (from /proc/version):
-[4.2.] Kernel .config file:
-[5.] Most recent kernel version which did not have the bug:
-[6.] Output of Oops.. message (if applicable) with symbolic information
-     resolved (see Documentation/oops-tracing.txt)
-[7.] A small shell script or example program which triggers the
-     problem (if possible)
-[8.] Environment
-[8.1.] Software (add the output of the ver_linux script here)
-[8.2.] Processor information (from /proc/cpuinfo):
-[8.3.] Module information (from /proc/modules):
-[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
-[8.5.] PCI information ('lspci -vvv' as root)
-[8.6.] SCSI information (from /proc/scsi/scsi)
-[8.7.] Other information that might be relevant to the problem
-       (please look in /proc and include all information that you
-       think to be relevant):
-[X.] Other notes, patches, fixes, workarounds:
+Reporting Linux kernel bugs
 
+What follows is a recommended procedure for reporting bug in the Linux kernel.
+Still, you are not obliged to use the suggested bug reporting format, it is
+provided as a guide to the kind of information that can be useful to developers.
+
+In general, the kernel developers' preferred way of reporting bugs is email,
+because it allows them to react quickly to the problems that are easy to fix.
+Still, later on, if the reported problem turns out to be difficult, you may be
+asked to open an entry in the kernel Bugzilla at http://bugzilla.kernel.org .
+Usually, this requires you to do some more work than just sending an email
+message with a bug report, but it often is necessary to collect all information
+related to the reported bug in one place, so that it is easily accessible at
+any time later.
+
+Email messages containing bug reports should generally be sent to the
+Linux Kernel Mailing List (LKML) <linux-kernel@vger.kernel.org> and to the
+mailing list dedicated to the affected subsystem.  You may send a bug report to
+three mailing lists simultaneously, if you think that it is necessry.
+[However, if you send them to more than three lists at a time, people will
+likely get angry with you.]
+
+It also is a good idea to notify the maintainer of the affected subsystem and
+the maintainer of the tree in which the bug is present by adding their email
+addresses to the Cc list of the bug report message.  The email addresses of
+maintainers of the majority of kernel subsystems can be found in the MAINTAINERS
+file, but you should not worry too much about getting a wrong person.
+
+If you know which patch has caused the problem to appear, you should also add
+the email address of its author to the Cc list of your bug report (this address
+is usually present in the 'From:' field of the patch header).  Additionally,
+it is recommended to notify all of the people involved in the process of
+merging the patch (you can find their addresses in the 'Signed-off-by:' and
+'Acked-by:' or 'Reviewed-by:' fields of the patch header).  This way you can
+increase the probability that someone "in the know" will notice the report and
+respond to it quickly.  Apart from this, you should make it clear that your
+message contains a bug report, for example by adding the word "BUG" in front
+of the message's subject line.  If the bug is a regression (ie. one of the
+previous kernel versions worked correctly), please put the word "REGRESSION" in
+there instead.
+
+Unfortunately, sometimes bug reports are not responded to even if they contain
+all of the right email addresses etc.  If that happens to your bug report, you
+should first check if it has not been intercepted by a spam filter.  This is
+easy if you have sent the report to a mailing list, since in that case it only
+is necessary to look into the list's archives to see if the message is there.
+If it turns out that the report has reached the list and no one is responding to
+it, the developers might have overlooked it or they may be too busy to take care
+of it right now.  In that case you should wait for some time (usually, a couple
+of days) and send it once again (if you resend the report, you may add the word
+"resend" to the message's subject to indicate that this is not the first time).
+If that does not help and there still is no response, it is best to open a new
+entry in the Bugzilla at http://bugzilla.kernel.org .  If you have already done
+that, send messages to the appropriate lists and people periodically to remind
+of the issue.
+
+As far as the contents of bug reports are concerned, you should generally avoid
+putting irrelevant information into them.  Of course, that may be difficult,
+because you may not know which information is relevant in given particular case.
+Still, you can always safely assume that if more information is needed, you will
+be asked to provide it.
+
+First of all, you need to say what the bug is, which kernel version it is
+present in and how to reproduce it.  You also need to describe the symptoms and
+include all of the corresponding kernel messages, if you can collect them.  In
+particular, if the failure includes an "Oops:" type message in your log or on
+screen please read "Documentation/oops-tracing.txt" before posting your bug
+report. This explains what you should do with the "Oops" information to make it
+useful to the recipient.
+
+Generally, the following things are appreciated in a bug report:
+
+* One line summary of the reported problem
+* Description of the problem
+* Version of the kernel in which the problem appears
+* The last known version of the kernel in which the problem does not appear (if
+  applicable)
+* Architecture of the system on which the problem is observed (that may
+  include some more detailed hardware information if the problem seems to be
+  hardware-related)
+* Steps to reproduce the problem
+* Kernel messages related to the problem (if available)
+* Concise description of software environment in which the problem appears (as
+  per the output of scripts/ver_linux)
+
+Additionally, if you know which patch has introduced the problem, the name of it
+or the corresponding git commit name should be included in the report.  [Please
+read Documentation/BUG-HUNTING to learn how you can find the "guilty" patch.]
+
+The version of the kernel can be read from the output of scripts/ver_linux or
+directly from /proc/version .  Still, if you use git to download the kernel
+sources, you can obtain more precise version information by running
+'git describe' from within the root of the kernel source directory.
+
+After reporting a bug you may be provided with a patch to test.  In that case
+you ought to test it and report back to the developer who have sent it to you
+whether or not it fixes the bug.  If it does not fix the bug, you will likely
+receive more patches to test.  In any case, please be patient and work with the
+developers until the issue is resolved.
 
 Thank you
+
