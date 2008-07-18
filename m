Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbYGRFD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbYGRFD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 01:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYGRFDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 01:03:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:23129 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYGRFDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 01:03:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=OLE55I05XaR2ldGgJDOartmscTScdYH4ZUSee/kXnZ3pIGQzmn46ORNXxA1o0D3O0y
         QIa6cVc5Za/NgBYvh4y0Bh+B3PNavuOklhUsK61Ely1ZS2/gIOLviNu8o5IrlHuLEmIa
         SrZkzhugX2KPFWDs2kr93XwwWQv4X6wBcawBQ=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, hjk@linutronix.de, gregkh@suse.de,
       akpm@linux-foundation.org
Date: Fri, 18 Jul 2008 14:04:02 +0900
Message-Id: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
Subject: [PATCH 00/06] uio: Various minor changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Here comes a few UIO changes that I've had in my queue for a while.

[PATCH 01/06] uio: Use struct_uio_mem instead of index
[PATCH 02/06] uio: Pass struct uio_mem to mmap functions
[PATCH 03/06] uio: Remove vma->vm_private_data from uio_find_mem()
[PATCH 04/06] uio: Store struct uio_mem ptr in vma->vm_private_data
[PATCH 05/06] uio: Remove redundant vma->vm_flags setup code
[PATCH 06/06] uio: Support multiple UIO_MEM_LOGICAL/VIRTUAL pages

Mostly small cleanups or performance improvements, except the last one
which contains a fix for unsupported multi-page LOGICAL/VIRTUAL maps.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Documentation/DocBook/uio-howto.tmpl |    2 
 drivers/uio/uio.c                    |   91 +++++++++++++++-------------------
 include/linux/uio_driver.h           |    1 
 3 files changed, 44 insertions(+), 50 deletions(-)
