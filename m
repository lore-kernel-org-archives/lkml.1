Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZBONdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZBONdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 08:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbZBONdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 08:33:21 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:51516 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbZBONdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 08:33:21 -0500
Date: Sun, 15 Feb 2009 14:35:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 01/10] ide: add flags query macros
Message-ID: <20090215133512.GA32621@uranus.ravnborg.org>
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com> <1234699692-9452-2-git-send-email-petkovbb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234699692-9452-2-git-send-email-petkovbb@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 01:08:03PM +0100, Borislav Petkov wrote:
> There should be no functionality change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  include/linux/ide.h |  166 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 166 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/ide.h b/include/linux/ide.h
> index c75631c..f133062 100644
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -497,6 +497,82 @@ enum {
>  	IDE_AFLAG_NO_AUTOCLOSE		= (1 << 24),
>  };
>  
> +#define ide_drv_drq_int(drive) \
> +	((drive)->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT)

Why not use a static inline here so we get proper typecheck.
And then convert the return result to a bool (0/1) so you
do not have to do this at the call site.

I counted at least three places in ide-cd that does a local
transformation to a bool and I saw nowhere the actual bit value
was used.

	Sam
