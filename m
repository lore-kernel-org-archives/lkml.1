Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbXGNImY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbXGNImY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 04:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbXGNImR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 04:42:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54268 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751708AbXGNImQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 04:42:16 -0400
Date: Sat, 14 Jul 2007 09:48:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk
Subject: Re: [PATCH] generic_nvram: use inode lock not lock_kernel
Message-ID: <20070714094837.073f9bae@the-village.bc.nu>
In-Reply-To: <20070713165840.70f5f382.akpm@linux-foundation.org>
References: <20070709144745.029094ae@the-village.bc.nu>
	<20070713165840.70f5f382.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Can we just use generic_file_llseek() in here?  afacit that simply requires
> that i_size have the correct value.  Does it?

Yes.

> Generic_file_llseek() uses file->f_mapping->host->i_mutex which is
> equivalent for this file, but we might as well be consistent.

Last time I used file->f_mapping->host-> for this in another driver Al
Viro asked me to use the f_path sequence instead. So I've always done
that since.

If it is correct to use the other then generic_file_llseek looks fine, if
not perhaps we need generic_device_llseek() ?

Al - there are many clones of these lseek methods - which should we be
using ?
