Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbXDZNlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbXDZNlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXDZNlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:41:05 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1806 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbXDZNlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:41:03 -0400
Message-ID: <4630ABF2.1040305@shadowen.org>
Date: Thu, 26 Apr 2007 14:41:06 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.21-rc7-mm2 -- PPC link failure
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <4630A662.8090502@shadowen.org>
In-Reply-To: <4630A662.8090502@shadowen.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Getting a link failure on a ppc64 system:
> 
>   LD      .tmp_vmlinux1
> init/built-in.o(.init.text+0x32e4): In function `.rd_load_image':
> : undefined reference to `.__kmalloc_size_too_large'
> fs/built-in.o(.text+0xa6fe0): In function `.ext3_fill_super':
> : undefined reference to `.__kmalloc_size_too_large'
> fs/built-in.o(.text+0xc1fe0): In function `.ext2_fill_super':
> : undefined reference to `.__kmalloc_size_too_large'
> fs/built-in.o(.text+0xf6a1c): In function `.nfs4_proc_lookup':
> : undefined reference to `.__kmalloc_size_too_large'
> fs/built-in.o(.text+0x104104): In function `.nfs_idmap_new':
> : undefined reference to `.__kmalloc_size_too_large'
> fs/built-in.o(.text+0x105520): more undefined references to
> `.__kmalloc_size_too_large' follow
> make: *** [.tmp_vmlinux1] Error 1

Ok, this is a SLUB related link failure.  Am investigating if PPC simply
needs larger allocs and needs CONFIG_LARGE_ALLOCS, of if this is an
inlining issue.

-apw
