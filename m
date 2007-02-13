Return-Path: <linux-kernel-owner+w=401wt.eu-S1751591AbXBMSuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbXBMSuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbXBMSuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:50:37 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:62006 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbXBMSug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:50:36 -0500
Date: Tue, 13 Feb 2007 10:48:39 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: perfmon@napali.hpl.hp.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net, eranian@hpl.hp.com,
       perfctr-devel@lists.sourceforge.net
Subject: 2.6.20 new perfmon code base + libpfm + pfmon
Message-ID: <20070213184839.GC10031@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have released another version of the perfmon new code base package.
This version of the kernel patch is relative to 2.6.20.

This  new kernel patch includes the following new features and
bug fixes:
	- first cut at supporting Oprofile on i386 and x86-64 architectures
	- several internal interfaces simplfications
	- various MIPS updates (Phil Mucci/Manoj Ekbote)
	- varous PPC32 updates (Phil Mucci)
	- fix bug in set switching with a single set
	- fix bug in pfm_restart() for per-thread mode with blocking notification

Unfortunately, this release does not build for PowerPC due to a problem with the
TIF_* flags. Perfmon adds 2 new flags which make the TIF now use more than 16 bits which
causes problem with some assembly instructions in entry_64.S. Hopefully,
this will be fixed in the next release.

To make Oprofile work, you need a modified user level Oprofile package. I have made
a first pass at modifying 0.9.2 to work on Perfmon 2.3 (and v2.0 for IA-64) for
the following processors: AMD Opteron, P6, Core Duo, Core 2 Duo, P4. The modified
package is available as Alpha at:

	ftp://ftp.hpl.hp.com/pub/linux-ia64/oprof-perfmon2-070122.diff

I have also released a new libpfm, libpfm-3.2-070206, with lots of
changes. Here are some of the most important ones:
	- Full Intel Core 2 Duo event table (Thanks to Dan Terpstra for his help)
	- Full event table for P6 and Pentium M (Dan Terpstra)
	- various MIPS updates (Phil Mucci)
	- improved Montecito event->counter assignment routine
   	- rewritten P6 event->counter assignment routine
   	- extended detect_unavail_pmcs() code to handle pmds
   	- extended whichpmu.c example to show implement vs.  available registers
	- possiblity to force a libpfm PMU different from host PMU
   	- several bug fixes to library and examples

Also a new version of pfmon, pfmon-3.2-070206, with a few changes:
	- rewritten the automatic sampling buffer sizing based on
     	  the resource limits (rlimits) and perfmon global settings
   	- Intel Core 2 Duo event listing now shows if event supports PEBS
   	- fixed important memory leak that showed up when monitoring across fork/pthread
	
You can get the packages and more detailed changelogs our the web site:

	 http://perfmon2.sf.net (go to Project Files)

Enjoy,

PS: home page not yet updated due to a problem connecting via ssh to SF.net today.

-- 

-Stephane
