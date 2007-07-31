Return-Path: <linux-kernel-owner+w=401wt.eu-S1763029AbXGaN0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763029AbXGaN0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760665AbXGaNYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:24:47 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:32976 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761934AbXGaNYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:24:45 -0400
Date: Tue, 31 Jul 2007 15:25:26 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu
Subject: Re: [PATCH 6/7] sysfs: make sysfs_add_one() automatically check for
 duplicate entry
Message-ID: <20070731152526.0e21e234@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <118587690812-git-send-email-htejun@gmail.com>
References: <11858769082982-git-send-email-htejun@gmail.com>
	<118587690812-git-send-email-htejun@gmail.com>
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

> Make sysfs_add_one() check for duplicate entry and return -EEXIST if
> such entry exists.  This simplifies node addition code a bit.
> 
> This patch doesn't introduce any noticeable behavior change.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  fs/sysfs/dir.c     |   25 ++++++++++++++++---------
>  fs/sysfs/file.c    |   12 +++++-------
>  fs/sysfs/symlink.c |    9 +++------
>  fs/sysfs/sysfs.h   |    2 +-
>  4 files changed, 25 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 8ce3ffb..69e57be 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -491,9 +491,15 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
>   *
>   *	LOCKING:
>   *	Determined by sysfs_addrm_start().
> + *
> + *	RETURNS:
> + *	0 on success, -errno on failure.

The only possible failure is -EEXIST, so I'd state that explicitly,
especially since you rely on that fact below.

Otherwise
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
