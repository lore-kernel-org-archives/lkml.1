Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbZIYNUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbZIYNUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 09:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbZIYNUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 09:20:00 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:43063 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZIYNT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 09:19:59 -0400
Date: Fri, 25 Sep 2009 18:49:58 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-s390@vger.kernel.org, adobriyan@gmail.com
Subject: linux-next: 20090925 - build breaks with !CONFIG_AIO
Message-ID: <20090925131958.GC6831@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20090925133830.1ba29584.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090925133830.1ba29584.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

	next-20090925 randconfig build breaks on s390x, with CONFIG_AIO=n.

arch/s390/mm/pgtable.c: In function 's390_enable_sie':
arch/s390/mm/pgtable.c:282: error: 'struct mm_struct' has no member named 'ioctx_list'
arch/s390/mm/pgtable.c:298: error: 'struct mm_struct' has no member named 'ioctx_list'
make[1]: *** [arch/s390/mm/pgtable.o] Error 1

Reverting the below commit helps

commit 858f09930b32c11b40fd0c5c467982ba09b10894
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Sep 23 15:57:32 2009 -0700

    aio: ifdef fields in mm_struct

	->ioctx_lock and ->ioctx_list are used only under CONFIG_AIO.
			    

			Kamalesh
