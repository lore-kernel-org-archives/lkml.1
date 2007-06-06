Return-Path: <linux-kernel-owner+w=401wt.eu-S965724AbXFFXlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965724AbXFFXlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965146AbXFFXlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:41:12 -0400
Received: from 8.sub-75-209-226.myvzw.com ([75.209.226.8]:59398 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964867AbXFFXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:41:11 -0400
X-Greylist: delayed 1518 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2007 19:41:08 EDT
Message-Id: <20070606225837.654272428@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jun 2007 15:58:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC 0/7] proposed updates to boot protocol and paravirt booting
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series:
 1. Updates the boot protocol to version 2.07
 2. Clean up the existing build process, to get rid of tools/build and
    make the linker do more heavy lifting
 3. Make the bzImage payload an ELF file.  The bootloader can extract
    this as a naked ELF file by skipping over boot_params.setup_sects worth
    of 16-bit setup code.
 4. Update the boot_params to 2.07, and update the kernel's head.S to
    jump to the appropriate subarch-specific kernel entrypoint.  The
    very earliest code is common (copy boot_params, clear bss); the
    split happens just before the initial pagetable setup.
+ random little changes to make it all hang together

This boots native for me, so everything basically works.  But I haven't
tested it end-to-end yet, because I haven't done the Xen bits yet.
Perhaps Rusty can do the lguest version to verify that its all sound in
principle (hint hint ;).

So, how does it look?

	J
-- 

