Return-Path: <linux-kernel-owner+w=401wt.eu-S1760955AbYBGMt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955AbYBGMt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759412AbYBGMsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:48:42 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:40695 "EHLO
	outbound6-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755989AbYBGMs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:48:27 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: KVM: add support for SVM Nested Paging
Date: Thu,  7 Feb 2008 13:47:37 +0100
Message-ID: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 07 Feb 2008 12:47:45.0642 (UTC)
 FILETIME=[A302A4A0:01C86987]
MIME-Version: 1.0
X-WSS-ID: 6BB421850QK10781141-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the improved patchset which adds support for the Nested Paging
feature of the AMD Barcelona and Phenom processors to KVM. The patch set
was successfully install- and runtime-tested with various guest
operating systems (64 bit, 32 bit legacy and 32 bit PAE Linux,
Windows 64 bit and 32 bit versions too).

To the previous post of these patches they were extended with support
for KVM on 32 bit PAE hosts. Live migration is also implemented and
tested in various situations (migration between 32 bit and 64 bit host,
Non-NPT to/from NPT migration, NPT to NPT migration, all with various
kinds of guests, including Windows).  After all these tests I am pretty
sure that these patches don't introduce any regression to KVM and
therefore the NPT feature is enabled per default.

Some new performance numbers are also available. For this test I started
an Ubuntu 7.10 guest with 4 vcpus and 3G of RAM on a dual socket Opteron
box and ran kernbench -M in it with a 2.6.24 kernel as the source tree.
The test was done with traditional Shadow Paging and using Nested
Paging. The tests ran on the text console with GDM stopped. Here are the
results:

-----------------------------------------------------------------------
Average Half load -j 3 Run:
-----------------+-------------------------+---------------------------
                 | Nested Paging           | Shadow Paging
-----------------+-------------------------+---------------------------
                 | Time    (std deviation) | Time    (std deviation)
-----------------+-------------------------+---------------------------
Elapsed Time     |   147.574 (0.642168)    |   211.73  (0.802963)
User Time        |   382.036 (1.14742)     |   416.254 (1.91732)
System Time      |    48.29  (0.261151)    |   221.608 (0.706307)
Percent CPU      |   291     (0.707107)    |   300.8   (0.447214)
Context Switches | 33605.4   (148.788)     | 34901     (434.318)
Sleeps           | 47351     (98.2395)     | 47017.8   (378.582)
-----------------+-------------------------+---------------------------
Average Half load -j 16 Run:
-----------------+-------------------------+---------------------------
                 | Nested Paging           | Shadow Paging
-----------------+-------------------------+---------------------------
                 | Time    (std deviation) | Time    (std deviation)
-----------------+-------------------------+---------------------------
Elapsed Time     |   120.156 (0.337757)    |   179.162 (1.49999)
User Time        |   385.318 (3.57206)     |   421.624 (5.82785)
System Time      |    48.959 (0.811411)    |   230.8   (9.70806)
Percent CPU      |   327.6   (38.5982)     |   336.2   (37.3655)
Context Switches | 42435.5   (9312.09)     | 46190.7   (11909.6)
Sleeps           | 50297.5   (3111.73)     | 50688     (3882.49)
-----------------+-------------------------+---------------------------

In other words, Nested Paging gave 30% performance improvement in the
'make -j 3' run and a 33% improvement in the 'make -j 16' run for this
benchmark.

I think these patches are ready for merging into the KVM tree. Please
consider for inclusion.

Joerg Roedel




