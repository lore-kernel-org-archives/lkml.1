Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbYBDJaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbYBDJaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 04:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbYBDJaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 04:30:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55541 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762AbYBDJaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 04:30:04 -0500
Date: Mon, 4 Feb 2008 01:28:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk,
       a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH] vfs: optimization to /proc/<pid>/mountinfo patch
Message-Id: <20080204012849.08c593e1.akpm@linux-foundation.org>
In-Reply-To: <1202116505.3949.91.camel@ram.us.ibm.com>
References: <E1JJqxt-0004r2-Vf@pomaz-ex.szeredi.hu>
	<20080130160839.828c4363.akpm@linux-foundation.org>
	<E1JKVY6-0001wd-BE@pomaz-ex.szeredi.hu>
	<1201805123.10358.23.camel@ram.us.ibm.com>
	<1202116505.3949.91.camel@ram.us.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2008 01:15:05 -0800 Ram Pai <linuxram@us.ibm.com> wrote:

> 1) reports deleted inode in dentry_path() consistent with that in __d_path()
> 2) modified __d_path() to use prepend(), reducing the size of __d_path()
> 3) moved all the functionality that reports mount information in /proc under
> 	CONFIG_PROC_FS.
> 
> Could not verify if the code would work with CONFIG_PROC_FS=n, since it was
> impossible to disable CONFIG_PROC_FS. Looking for ideas on how to disable
> CONFIG_PROC_FS.
> 	

Do `make menuconfig', then hit '/' and search for "proc_fs".

It'll tell you that you need to set EMBEDDED=y to disable procfs.

>  fs/dcache.c              |   59 +++++++++++++++++++----------------------------
>  fs/namespace.c           |    2 +
>  fs/seq_file.c            |    2 +
>  include/linux/dcache.h   |    3 ++
>  include/linux/seq_file.h |    3 ++

Please resend after testing that, thanks.

