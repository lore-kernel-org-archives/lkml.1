Return-Path: <linux-kernel-owner+w=401wt.eu-S1762666AbXKTUeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666AbXKTUeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759619AbXKTUe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:34:29 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:43101 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394AbXKTUe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:34:28 -0500
Message-ID: <474344D0.40704@linux.vnet.ibm.com>
Date: Wed, 21 Nov 2007 02:04:24 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       paul.moore@hp.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45.tar.gz uploaded
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
In-Reply-To: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails, in selinux with following error

  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
security/built-in.o(.toc1+0x928): undefined reference to `selinux_xfrm_refcount'
make: *** [.tmp_vmlinux1] Error 1
11/20/2007-14:42:08 Build the kernel. Failed rc = 2
11/20/2007-14:42:08 build: Building kernel... Failed rc = 1

The patch causing this error is git-lblnet.patch, where in the selinux_xfrm_enabled()
is called from security/selinux/hooks.c, depends on the extern atomic_tselinux_xfrm_refcount.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
