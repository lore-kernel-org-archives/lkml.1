Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbXGCEh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbXGCEh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 00:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbXGCEhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 00:37:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbXGCEhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 00:37:12 -0400
Date: Mon, 2 Jul 2007 21:37:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org, Greg K-H <greg@kroah.com>
Subject: Re: [PATCH 08/12] only schedule work once
Message-Id: <20070702213704.4dbff811.akpm@linux-foundation.org>
In-Reply-To: <b21709fe9108128c75c78a29597d5fc3d19049ba.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
	<b21709fe9108128c75c78a29597d5fc3d19049ba.1182883861.git.ecashin@coraid.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 14:50:12 -0400 "Ed L. Cashin" <ecashin@coraid.com> wrote:

> Only schedule work once.

why?

> Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
> ---
>  drivers/block/aoe/aoecmd.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
> index 89df9de..8d6540b 100644
> --- a/drivers/block/aoe/aoecmd.c
> +++ b/drivers/block/aoe/aoecmd.c
> @@ -681,6 +681,8 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
>  			d->fw_ver, (long long)ssize);
>  	d->ssize = ssize;
>  	d->geo.start = 0;
> +	if (d->flags & (DEVFL_GDALLOC|DEVFL_NEWSIZE))
> +		return;
>  	if (d->gd != NULL) {
>  		d->gd->capacity = ssize;
>  		d->flags |= DEVFL_NEWSIZE;
