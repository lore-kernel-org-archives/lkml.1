Return-Path: <linux-kernel-owner+w=401wt.eu-S1761460AbYFXOfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761460AbYFXOfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbYFXOeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:34:50 -0400
Received: from ns2.suse.de ([195.135.220.15]:40812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbYFXOes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:34:48 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       Bernhard Walle <bwalle@suse.de>
Subject: Limit E820 map when specifying mem parameter
Date: Tue, 24 Jun 2008 16:35:22 +0200
Message-Id: <1214318125-32619-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the E820 map when specifying the mem kernel command line
parameter. That's the behaviour i386 had before the merging work in the
current "tip" tree.

As Yinghai Lu pointed out in email discussion, e820_update_range() should be
used for the updating instead of an own function. Two modifications in
e820_update_range() are necessary:

 1. Fix a small bug that prevented the partically covered entry from
    being stripped (size is not updated).
 
 2. Small API extension to be able to specify size == ULLONG_MAX to 
    update the whole map from size to the end.

The modification is necessary that kexec can build the ELF core headers only
for the used memory. Once the exporting of the real, unmodified memory map is
in the kernel, kexec can use the raw map and still reboot with full memory
size.

The patch is against 2.6.26-rc7-tip and has been successfully tested on i386
and x86-64, with and without "mem" parameter.


Signed-off-by: Bernhard Walle <bwalle@suse.de>


