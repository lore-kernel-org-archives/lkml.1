Return-Path: <linux-kernel-owner+w=401wt.eu-S1764286AbXKTU52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764286AbXKTU52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762489AbXKTU4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:56:55 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:29370 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638AbXKTU4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:56:52 -0500
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 15:56:52 EST
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45.tar.gz uploaded
Date: Tue, 20 Nov 2007 15:48:44 -0500
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org> <474344D0.40704@linux.vnet.ibm.com>
In-Reply-To: <474344D0.40704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201548.44542.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 3:34:24 pm Kamalesh Babulal wrote:
> Hi Andrew,
>
> The kernel build fails, in selinux with following error
>
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> security/built-in.o(.toc1+0x928): undefined reference to
> `selinux_xfrm_refcount' make: *** [.tmp_vmlinux1] Error 1
> 11/20/2007-14:42:08 Build the kernel. Failed rc = 2
> 11/20/2007-14:42:08 build: Building kernel... Failed rc = 1
>
> The patch causing this error is git-lblnet.patch, where in the
> selinux_xfrm_enabled() is called from security/selinux/hooks.c, depends on
> the extern atomic_tselinux_xfrm_refcount.

The problem appears to be that the selinux_xfrm_refcount functionality is not 
properly protected by CONFIG_SECURITY_NETWORK_XFRM.  I'm fixing that now.

-- 
paul moore
linux security @ hp
