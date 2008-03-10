Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYCJQ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYCJQ0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYCJQ0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:26:05 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:24256 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYCJQ0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:26:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=seekglpS8rabGobLQmWGcWWPXzCpg0UhpV8ruMAYmBJ0ANfsZdtfpa57VWczulqLcbrp+dTWQeCG2ToocMKdi23HRYgHxpzAaTeTVC/Fs1joROqasBH08L8BwL9SjvEMbHAOibIxB4y0QW6u3EHvPEASVhSyAvmd5ox6d828ApM=
Message-ID: <87a5b0800803100926t1e4a1bb3t905d02d4c311d5e@mail.gmail.com>
Date: Mon, 10 Mar 2008 16:26:02 +0000
From: "Will Newton" <will.newton@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: copy_page_range() with VM_LOCKED
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In order to optimize fork performance copy_page_range avoids copying
page tables under certain circumstances:

        if (!(vma->vm_flags &
(VM_HUGETLB|VM_NONLINEAR|VM_PFNMAP|VM_INSERTPAGE))) {
                if (!vma->anon_vma)
                        return 0;
        }

I have a VM_LOCKED vma that I would really, really like not to fault
on, but because copy_page_range does not copy the page tables of the
vma I do end up faulting in my VM_LOCKED vma. Now as far as I'm aware
mmap with MAP_LOCKED only promises the page will not be paged out, not
that the page will never fault but I would like to get that behaviour.

Would it be possible to add VM_LOCKED to the above conditional so
copy_page_range would always copy VM_LOCKED vma page tables or would
that be considered insane and broken?

Thanks,
