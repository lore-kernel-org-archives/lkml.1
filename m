Return-Path: <linux-kernel-owner+w=401wt.eu-S1761791AbXFFJz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761791AbXFFJz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757796AbXFFJzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:55:15 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:34826 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755745AbXFFJzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:55:13 -0400
X-Greylist: delayed 945 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2007 05:55:13 EDT
Date: Wed, 06 Jun 2007 11:39:26 +0200
From: Boris Bierbaum <boris@lfbs.RWTH-Aachen.DE>
Subject: How to map physical pages into vma
To: linux-kernel@vger.kernel.org
Message-id: <466680CE.6010403@lfbs.rwth-aachen.de>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
X-IronPort-AV: E=Sophos;i="4.16,389,1175472000";   d="scan'208";a="397995"
X-Enigmail-Version: 0.94.2.0
User-Agent: Icedove 1.5.0.10 (X11/20070329)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

inside of a kernel module, I need to re-map a part of a processes'
virtual address space (usually from the heap) to a range of physically
contiguous page frames that another kernel module provides me with (I
get a kernel virtual address to the beginning of the first page frame).

I tried remap_pfn_range(), but as Copy-on-Write is used for the heap's
vma, remap_pfn_range() refuses to do the mapping, because I only want to
re-map some part of the vma, not the whole thing.

Then I tried to use vm_insert_page() for each individual physical page,
but as the count is 0 for these pages, this is refused, too.

I can't use split_vma() to split the heap's vma twice and then use
remap_pfn_range() for the vma that represents the part that is to be
re-mapped, because split_vma() isn't supposed to be called from inside a
module, right?

Is there anything I can do about this?

Thanks in advance
Boris


-- 
|  _  RWTH | Boris Bierbaum
|_|_`_     | Lehrstuhl fuer Betriebssysteme
   | |_) _  | RWTH Aachen D-52056 Aachen
     |_)(_` | Tel: +49-241-80-27805
        ._) | Fax: +49-241-80-22339
