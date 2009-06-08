Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZFHL4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZFHL4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 07:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbZFHL4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 07:56:02 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:57784 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbZFHL4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 07:56:01 -0400
Message-ID: <4A2CFC51.1040604@msgid.tls.msk.ru>
Date: Mon, 08 Jun 2009 15:56:01 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
Subject: initramfs unpacking failed: junk in compressed archive
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc'd HPA since he touched this code recently]

My second issue with 2.6.30-rc8, this time without any
additional patches.

It fails to decompress gzip-compressed initramfs here, says this
way before many other things and continues booting, failing down
the line obviously, but the root cause is already gone off the
screen (previously it paniced if it were unable to unpack initramfs).

the key error message is like in $subject.

I've added a printk right when it sets the above error in unpack_to_rootfs(),
right after the ckeck for "state != Reset".  The `state' value is 0 there,
for "Start".

The kernel is x86-64, machine is AMD x2-64 with 4G RAM.
The problem does not occur when running in a KVM virtual machine with only
512 megs of ram, the same kernel and the same initramfs (so this eliminates
corrupt initramfs, which also passes `gzip -t' test).

The same config (mkinitrd/modules/etc) worked for me on every kernel since
a stone age maybe (early 2.6 series).

I'll do some more experiments with it later today, hopefully - like
trying 32bits kernel, reducing amount of memory etc.

Thanks.

/mjt
