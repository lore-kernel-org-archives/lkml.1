Return-Path: <linux-kernel-owner+w=401wt.eu-S1763326AbXEVSk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763326AbXEVSk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757137AbXEVSkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:40:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40706 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756432AbXEVSks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:40:48 -0400
Date: Tue, 22 May 2007 11:39:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UDF: possible usage of uninitialized variables
Message-Id: <20070522113926.b7f1e690.akpm@linux-foundation.org>
In-Reply-To: <20070522175223.GA8259@cvg>
References: <20070522175223.GA8259@cvg>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 21:52:23 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> A few variables could be used without being explicitly initialized.
> Fixed.

Are you sure?  I'm expecting that this is a gcc mistake.

> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> 
>  balloc.c |    6 +++++-
>  super.c  |    5 ++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/balloc.c b/balloc.c
> index 4cec910..be37393 100644
> --- a/balloc.c
> +++ b/balloc.c

Please always use `patch -p1' form from the top-level directory.  This should
have been

--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c

> @@ -744,7 +744,11 @@ static int udf_table_new_block(struct super_block * sb,
>  	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
>  	uint32_t newblock = 0, adsize;
>  	uint32_t elen, goal_elen = 0;
> -	kernel_lb_addr eloc, goal_eloc;
> +	kernel_lb_addr eloc;
> +	kernel_lb_addr goal_eloc = {
> +		.logicalBlockNum = 0,
> +		.partitionReferenceNum = 0,
> +	};

	kernel_lb_addr goal_eloc = { };

is equivalent and sufficient.
