Return-Path: <linux-kernel-owner+w=401wt.eu-S1030304AbXBRF32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030304AbXBRF32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 00:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030303AbXBRF32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 00:29:28 -0500
Received: from gw.goop.org ([64.81.55.164]:59143 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030298AbXBRF31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 00:29:27 -0500
Message-ID: <45D7E438.4020902@goop.org>
Date: Sat, 17 Feb 2007 21:29:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-arch@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Which architectures need to sync vmalloc mappings between processes?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking at making all architectures export a vmalloc_sync_all()
function, so that generic code can be sure that a particular vmalloc
mapping is present in all address spaces.   I need this to implement a
function to reserve a chunk of vmalloc address space complete with
constructed pagetables, but without allocating any actual data pages.

On i386 with PAE, this is not necessary because the kernel's mappings
are shared between all processes anyway, so it would be a no-op.  
However, non-PAE i386 has a separate kernel mapping for each process,
and so needs to sync them - typically lazily on faults, but
vmalloc_sync_all exists to allow mass syncing when required.

What other architectures would require syncing of vmalloc mappings, and
what architectures would implement it as a no-op?

Thanks,
    J
