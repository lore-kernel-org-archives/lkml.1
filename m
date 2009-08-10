Return-Path: <linux-kernel-owner+w=401wt.eu-S1751389AbZHJG2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbZHJG2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 02:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbZHJG2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 02:28:22 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:25171 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbZHJG2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 02:28:21 -0400
MIME-Version: 1.0
Date: Mon, 10 Aug 2009 16:28:22 +1000
Message-ID: <1d3f23370908092328l6e980f3ft2d5a8f8f37c26fcf@mail.gmail.com>
Subject: Rethinking MicroBlaze commandline precedence
From: John Williams <john.williams@petalogix.com>
To: Michal Simek <michal.simek@petalogix.com>,
       John Linn <John.Linn@xilinx.com>,
       David DeBonis <david.debonis@xilinx.com>
Cc: microblaze-uclinux@itee.uq.edu.au,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently, MicroBlaze commandline handling in order of lowest to
highest priority, looks like this:

1. pointer in r5 from bootloader
2. CONFIG_CMDLINE=...
3. "chosen" section in DTS/DT
4. CONFIG_CMDLINE=... && CONFIG_CMDLINE_FORCE

I'm wondering if a cmdline in r5 should override the DTS.  My thinking
is based on two observations:

(a) not everyone will use a bootloader like u-boot that can manipulate
DTBs easily before kernel boot
(b) a custom cmdline string in r5 allows the latest possible binding
(runtime), where as the DTB is typically created at compile time.

So, how about this order instead:

1. CONFIG_CMDLINE=...
2. "chosen" section in DTS/DT
3. pointer in r5 from bootloader
4. CONFIG_CMDLINE=... and CONFIG_CMDLINE_FORCE

Then, apart from CMDLINE_FORCE, the precedence goes from earliest
binding (kernel build) to latest (runtime via bootloader/r5).

Thoughts?

John
-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
