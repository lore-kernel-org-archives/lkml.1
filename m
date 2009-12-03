Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZLCPiC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZLCPiC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:38:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZLCPiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:38:00 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:38164 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZLCPg7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 3 Dec 2009 10:36:59 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jayakumar.lkml@gmail.com, damm@opensource.se, linux-kernel@vger.kernel.org
Cc: armbru@redhat.com, jeremy@goop.org
Subject: [PATCH] fb-defio: Inhibit setting VM_IO flag if FBINFO_VIRTFB is set.
Date: Thu,  3 Dec 2009 10:31:55 -0500
Message-Id: <1259854318-16907-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B17DB0B.01A1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jaya and Magnus,

I was wondering if I could get your opinion and hopefully an ACK on these
following patches?  They fix an issue when Linux is running in a Xen paravirt
environment with the framebuffer enabled. This bug looks to have been in
existence for a long time and finally has been tracked down.

Essentially the VM_IO flag, that is set in fb_deferred_io_mmap, has a special
meaning for Xen-paravirt Linux. It is used to signify pages that are backed by
PCI devices memory (BARs, and such). Having other types of memory (System RAM)
marked with this flag, throws a monkey wrench in the accounting and we end
up with infinite General Protection Fault occurring during boot-up.

The first two patches fix the problem. The last one is a cleanup of the
other users of fb_deferred that use a framebuffer allocated from System RAM.

Thank you for taking the time to review these patches.

Sincerely,

Konrad Rzeszutek Wilk
