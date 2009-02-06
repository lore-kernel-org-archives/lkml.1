Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbZBFRLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbZBFRLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZBFRLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:11:08 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:46654 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZBFRLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:11:07 -0500
Subject: [BUG] binfmt_elf: get_user() called in vma_dump_size() after
	set_fs(KERNEL_DS)
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 18:10:35 +0100
Message-Id: <1233940235.22140.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

elf_core_dump() does a set_fs(KERNEL_DS) and then calls vma_dump_size(),
which uses get_user() to check for an ELF header at vma->vm_start in the
user mapping. This is a bug because vm_start is a user virtual address and
get_user() will fail or even read from a kernel address (KERNEL_DS).

Maybe a get_user_pages() should be used to get the user data, or a temporary
set_fs(USER_DS)?

--
Gerald


