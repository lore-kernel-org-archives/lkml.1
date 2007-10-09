Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbXJIGiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbXJIGiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 02:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbXJIGiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 02:38:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:63255 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbXJIGiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 02:38:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,246,1188802800"; 
   d="scan'208";a="339946007"
Subject: [PATCH -mm -v4 0/3] i386/x86_64 boot: 32-bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Oct 2007 14:40:03 +0800
Message-Id: <1191912003.9719.17.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 09 Oct 2007 06:37:57.0188 (UTC) FILETIME=[EDAD8040:01C80A3E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset defines a 32-bit boot protocol for i386/x86_64 platform,
adds an extensible boot parameter passing mechanism, export the boot
parameters via sysfs.

The patchset has been tested against 2.6.23-rc8-mm2 kernel on x86_64
and i386.

This patchset is based on the proposal of Peter Anvin.


Known Issues:

- Where is safe to place the linked list of setup_data?  Because the
  length of the linked list of setup_data is variable, it can not be
  copied into BSS segment of kernel as that of "zero page". We must
  find a safe place for it, where it will not be overwritten by kernel
  during booting up. The i386 kernel will overwrite some pages after
  _end. The x86_64 kernel will overwrite some pages from 0x1000 on.

- The fields in zero page are fairly complex (such as struct
  edd_info). Is it necessary to document every field inside the first
  level fields, until the primary data type? Or is it sufficient to
  provide the C struct name only?

- Which fields of boot parameters should be exported directly in
  sysfs? Export all fields of boot parameters in sysfs is too complex
  and unnecessary. Which fields should be?


-v4

* Reserve setup_data and boot parameters for accessing during
  runtime.
* Export boot parameters via sysfs.

-v3

* Move hd0_info and hd1_info back to zero page for compatibility.

-v2

* Increase the boot protocol version number
* Check version number before parsing setup data.
* Revise zero page description according to the source code and move
  them to zero-page.txt.


Best Regards,
Huang Ying
