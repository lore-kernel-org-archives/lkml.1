Return-Path: <linux-kernel-owner+w=401wt.eu-S1763687AbXGaNO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763687AbXGaNO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762542AbXGaNMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:12:43 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:51842 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762771AbXGaNMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:12:41 -0400
Date: Tue, 31 Jul 2007 15:13:11 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu
Subject: Re: [PATCH 5/7] sysfs: make sysfs_add/remove_one() call
 link/unlink_sibling() implictly
Message-ID: <20070731151311.1e02626b@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11858769082486-git-send-email-htejun@gmail.com>
References: <11858769082982-git-send-email-htejun@gmail.com>
	<11858769082486-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 19:15:08 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> When adding or removing a sysfs_dirent, the user used to be required
> to call link/unlink separately.  It was for two reasons - code looked
> like that before sysfs_addrm_cxt conversion and to avoid looping
> through parent_sd->children list twice during removal.
> 
> Performance optimization during removal just isn't worth it.  Make
> sysfs_add/remove_one() call sysfs_link/unlink_sibing() implicitly.
> This makes code simpler albeit slightly less efficient.  This change
> doesn't introduce any noticeable behavior change.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  fs/sysfs/dir.c     |   21 ++++++++++-----------
>  fs/sysfs/file.c    |    4 +---
>  fs/sysfs/inode.c   |   17 ++++-------------
>  fs/sysfs/symlink.c |    4 +---
>  fs/sysfs/sysfs.h   |    2 --
>  5 files changed, 16 insertions(+), 32 deletions(-)
> 
I agree. The double loop in the removal path doesn't really hurt, and
the code is now much nicer.

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
