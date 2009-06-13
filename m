Return-Path: <linux-kernel-owner+w=401wt.eu-S1762979AbZFMNYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762979AbZFMNYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZFMNYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:24:33 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:51715 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbZFMNYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=f0dsBZleUnnh/CbyR8K8Mq8/8xwfMk0VaavG/YLf8xwrUaHgunDr2zbs51KzuFNMuY
         SkAOunICWJ7FWgFuS+1wlM+CLYss3/kNCVABT+fmbvwQt1IDZnP5YvU5FWQL98rMgV3K
         BFn2862A4KBD7syW8BDKigcBQE0oN9zRNWwdA=
Message-ID: <4A33A7A2.1050608@gmail.com>
Date: Sat, 13 Jun 2009 15:20:34 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Daniel Walker <dwalker@soe.ucsc.edu>
Subject: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a second attempt at mainlining Pramfs. The first attempt was
back in early 2004 by MontaVista. Since then the kernel code has almost
been completely rewritten. So my first item on the list was porting the
code on a recent kernel version. After that I added the XIP support.

Now some FAQs:

What is the goal of this filesystem?

Many embedded systems have a block of non-volatile RAM separate from
normal system memory, i.e. of which the kernel maintains no memory page
descriptors. For such systems it would be beneficial to mount a
fast read/write filesystem over this "I/O memory", for storing
frequently accessed data that must survive system reboots and power
cycles. An example usage might be system logs under /var/log, or a user
address book in a cell phone or PDA.

Why this kind of filesystem should be "mainlined"?

Linux traditionally had no support for a persistent, non-volatile
RAM-based filesystem, persistent meaning the filesystem survives a
system reboot or power cycle intact. The RAM-based filesystems such as
tmpfs and ramfs have no actual backing store but exist entirely in the
page and buffer caches, hence the filesystem disappears after a system
reboot or power cycle.

Are there any pending patents on this code?

NO, there aren't patents pending on this code. MontaVista had a pending
patent application but now it has abandoned this way. Daniel Walker can
confirm that.


Marco



