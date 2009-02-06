Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbZBFVp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbZBFVp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 16:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbZBFVpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 16:45:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243AbZBFVps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 16:45:48 -0500
Date: Fri, 6 Feb 2009 13:44:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org
Subject: Re: [BUG] binfmt_elf: get_user() called in vma_dump_size() after
 set_fs(KERNEL_DS)
Message-Id: <20090206134410.d548b72c.akpm@linux-foundation.org>
In-Reply-To: <1233940235.22140.9.camel@localhost.localdomain>
References: <1233940235.22140.9.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Feb 2009 18:10:35 +0100
Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> Hi,
> 
> elf_core_dump() does a set_fs(KERNEL_DS) and then calls vma_dump_size(),
> which uses get_user() to check for an ELF header at vma->vm_start in the
> user mapping. This is a bug because vm_start is a user virtual address and
> get_user() will fail or even read from a kernel address (KERNEL_DS).
> 
> Maybe a get_user_pages() should be used to get the user data, or a temporary
> set_fs(USER_DS)?
> 

Could use __get_user() to skip the access_ok() check?

We'd need to be sure that the address isn't a kernel address or iomem
or something. 
