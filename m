Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbYCBUy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbYCBUy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759720AbYCBUyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:54:36 -0500
Received: from aun.it.uu.se ([130.238.12.36]:33521 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759156AbYCBUyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:54:31 -0500
Date: Sun, 2 Mar 2008 21:53:25 +0100 (MET)
Message-Id: <200803022053.m22KrP2Y023591@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.25-rc2-git3 broke cdrecord
Cc: James.Bottomley@HansenPartnership.com, htejun@gmail.com,
       jens.axboe@oracle.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my main workstation (Intel P965 chipset, ICH8 SATA driven by ahci,
Samsung/Toshiba SH-203P SATA DVD writer, FC5 user-space), cdrecord
stopped working on the 2.6.25-rc3 kernel, with the complaint:

Warning: controller returns zero sized CD capabilities page.
Warning: controller returns wrong page 0 for CD capabilities page (2A).

There's nothing in dmesg to suggest that the kernel has experienced
some problem.

2.6.25-rc2-git2 was the last working kernel, 2.6.25-rc2-git3 up to
today's 2.6.25-rc3-git3 are all non-working.

I've narrowed the cause down to these two commits in 2.6.25-rc2-git3:

40b01b9bbdf51ae543a04744283bf2d56c4a6afa
block: update bio according to DMA alignment padding

6b00769fe1502b4ad97bb327ef7ac971b208bfb5
block: add request->raw_data_len

Four or so subsequent commits depend on the second of these, so it's
easier to test them by applying them to -git2 than to revert them.

Also, these two need to be treated as a unit. With only the first
applied, I get a massive delay as init tries to start udev, and then
if I try cdrecord it hangs in an unkillable state.

I've put some information in
<http://user.it.uu.se/~mikpe/linux/bug-2.6.25-rc3-cdrecord/>:
- the kernel's .config
- cdrecord -VV dev=/dev/scd0 blank=fast output for 2.6.25-rc2-git2 and -git3
- strace -v logs for the above cdrecord runs

/Mikael
