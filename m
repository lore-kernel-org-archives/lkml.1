Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYKDQJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYKDQJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYKDQJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:09:39 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:16268 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753630AbYKDQJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:09:38 -0500
Message-ID: <491073BB.4000900@panasas.com>
Date: Tue, 04 Nov 2008 18:09:31 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, open-osd ml <osd-dev@open-osd.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
CC: Sami.Iren@seagate.com, Pete Wyckoff <pw@padd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCHSET 00/18] open-osd: OSD Initiator library for Linux
References: <48876009.8010701@panasas.com>
In-Reply-To: <48876009.8010701@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2008 16:08:18.0264 (UTC) FILETIME=[8CF54D80:01C93E97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please consider for inclusion, an in-kernel OSD initiator
library. Its main users are planned to be various OSD based file
systems and the pNFS-Objects Layout Driver. (To be submitted soon)
 
To try out and run the library please visit
http://open-osd.org and follow the instructions there.

The submitted patchset is also available via git at:
   git://git.open-osd.org/linux-open-osd.git osd
   http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=osd

Or a compact out-of-tree repository that includes sources 
and some extras:
   git://git.open-osd.org/open-osd.git master
   http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=summary

The submitted patches add public header files to include/scsi/
for use by other subsystems. The source files and private headers 
are put at a new drivers/scsi/osd/ directory, with the privilege of
a separate Makefile and Kconfig.

here is the list of patches:

[PATCH 01/18] major.h: char-major number for OSD device driver
	A request for a new char-device major number

[PATCH 02/18] scsi: OSD_TYPE
	The OSD scsi type constant definition.

[PATCH 03/18] libosd: OSDv1 Headers
[PATCH 04/18] libosd: OSDv1 preliminary implementation
  Most basic, but usable library module (libosd.ko) including
  Kbuild/Makefile.

[PATCH 05/18] osd_uld: OSD scsi ULD
[PATCH 06/18] osd_uld: API for retrieving osd devices from Kernel
[PATCH 07/18] osd_test: User-mode application to run the OSD tests
[PATCH 08/18] osd_ktests: Add basic OSD tests
  These patches add a scsi ULD for OSD type devices. Please see
  commit logs for details.

[PATCH 09/18] libosd: attributes Support
[PATCH 10/18] osd_ktests: Test Attribute lists
[PATCH 11/18] libosd: OSD Security processing stubs
[PATCH 12/18] libosd: Add Flush and List-objects support
[PATCH 13/18] libosd: Not implemented commands
[PATCH 14/18] libosd: OSD version 2 Support
[PATCH 15/18] libosd: OSDv2 auto detection
  Up to here this is a fairly complete body of work, to support
  both OSD1 and OSD2 targets. Main pieces that are still missing
  from the library at this point are: The OSD2 capabilities structure,
  do to lack of an OSD target that supports it, so it was never tested.
  And the absence of any OSD-security methods other then NO_SECURITY.
  These will come in future versions.

[PATCH 16/18] osd: Documentation for OSD library
  Some reading about OSD in general and further usability instructions.
  Please comment on anything missing from this document.

[PATCH 17/18] osd: Kconfig file for in-tree builds
[PATCH 18/18] scsi: Add osd library to build system
  The in-tree compilation is only enabled at the end of the patchset.
  Run your favorite configure-tool to enable the library and osd_uld
  compilation. Default is off.
  The patchset is however fully bisectable and compilable from the beginning if
  Invoked out-of-tree style with the -M switch. (see out-of-tree URL for how)

We would like this to sit in -mm tree for a while to make sure it is compilable
on all platform. We don't see any danger of it being included in the next Kernel
as it will not break anything. Of course, given that we have addressed everyone's
comments, at this round.

What's new/changed since the last RFC:
  Mainly work has been done to address James comments about the ULD.
See http://archive.netbsd.se/?ml=linux-scsi&a=2008-07&m=8051556
I hope I've nailed down all possible problems in the reference
counting / locking of both the osd_uld_device structure , and the MODULE.
Also a new API was devised for in-kernel users to query for osd devices.
See: "[PATCH 06/18] osd_uld: API for retrieving osd devices from Kernel"
for further discussion on this subject.
  Also the development and support of osdfs, submitted as RFC last week, was
a good test bed for stability and usability. So there were a few fixes and
cleanups do to that effort.

All-in-all I'm very confident in this work and feel it can serve as a good
base for OSD work in the Linux Kernel. We welcome anyone to please try this
SW, test it, break it to pieces, and please tell us about your experience.

Thanks
Boaz

