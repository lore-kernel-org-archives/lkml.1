Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbZJCFoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbZJCFoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 01:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZJCFoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 01:44:44 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:44119 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZJCFon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 01:44:43 -0400
Date: Sat, 03 Oct 2009 01:44:42 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sfi-devel@simplefirmware.org
Subject: [git pull request] SFI patches for 2.6.31-rc1
Message-id: <alpine.LFD.2.00.0910030142370.25240@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git sfi-release

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on sfi-devel@simplefirmware.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/sfi/patches/2.6.32/acpi-sfi-release-20090903-2.6.32-rc2.diff.gz

 drivers/sfi/sfi_core.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

through these commits:

Arjan van de Ven (1):
      SFI: remove __init from sfi_verify_table

Rakib Mullick (1):
      SFI: fix section mismatch warnings in sfi_core.c

with this log:

commit 011a606d0670196c17110b6770e39cc0865aa614
Author: Arjan van de Ven <arjan@infradead.org>
Date:   Fri Oct 2 07:29:47 2009 -0700

    SFI: remove __init from sfi_verify_table
    
    sfi_verify_table() is called at runtime, and thus cannot be __init
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 01674da6f587a3f3940eedf2c1e97d51c35b994e
Author: Rakib Mullick <rakib.mullick@gmail.com>
Date:   Wed Sep 30 16:09:55 2009 -0700

    SFI: fix section mismatch warnings in sfi_core.c
    
    The function sfi_map_memory/sfi_unmap_memory uses
    early_ioremap/early_iounmap respectively, which refers to a __init
    function.  And function sfi_check_table also refers to a __init function
    sfi_verify_table.  Since the references are valid, so use __ref to get rid
    of the warnings.
    
     We were warned by the following warnings:
    
      LD      vmlinux.o
      MODPOST vmlinux.o
    WARNING: vmlinux.o(.text+0xb6ba3a): Section mismatch in reference from
    the function sfi_map_memory() to the function
    .init.text:early_ioremap()
    The function sfi_map_memory() references
    the function __init early_ioremap().
    This is often because sfi_map_memory lacks a __init
    annotation or the annotation of early_ioremap is wrong.
    
    WARNING: vmlinux.o(.text+0xb6bab6): Section mismatch in reference from
    the function sfi_unmap_memory() to the function
    .init.text:early_iounmap()
    The function sfi_unmap_memory() references
    the function __init early_iounmap().
    This is often because sfi_unmap_memory lacks a __init
    annotation or the annotation of early_iounmap is wrong.
    
    WARNING: vmlinux.o(.text+0xb6be30): Section mismatch in reference from
    the function sfi_check_table() to the function
    .init.text:sfi_verify_table()
    The function sfi_check_table() references
    the function __init sfi_verify_table().
    This is often because sfi_check_table lacks a __init
    annotation or the annotation of sfi_verify_table is wrong.
    
    Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>
