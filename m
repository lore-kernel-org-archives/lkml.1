Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYFYMCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYFYMCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbYFYMBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:01:46 -0400
Received: from mx1.suse.de ([195.135.220.2]:51072 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbYFYMBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:01:45 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com
Subject: Limit E820 map when specifying mem parameter
Date: Wed, 25 Jun 2008 14:02:19 +0200
Message-Id: <1214395342-20375-1-git-send-email-bwalle@suse.de>
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



