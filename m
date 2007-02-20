Return-Path: <linux-kernel-owner+w=401wt.eu-S1750930AbXBTBfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbXBTBfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 20:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbXBTBfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 20:35:19 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47429 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750889AbXBTBfS (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 20:35:18 -0500
X-Greylist: delayed 1648 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Feb 2007 20:35:18 EST
Date: Tue, 20 Feb 2007 12:08:20 +1100
From: Timothy Shimmin <tes@sgi.com>
To: xfs-masters@oss.sgi.com, David Chinner <dgc@sgi.com>, bunk@stusta.de
cc: linux-kernel@vger.kernel.org
Subject: Re: [xfs-masters] [2.6 patch] make xfs_buftarg_list static again
Message-ID: <8A32D9770F6D2A7EAB6016A0@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070220000747.GC13958@stusta.de>
References: <20070220000747.GC13958@stusta.de>
X-Mailer: Mulberry/4.0.6 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

--On 20 February 2007 1:07:47 AM +0100 Adrian Bunk <bunk@stusta.de> wrote:

> xfs_buftarg_list became global for no good reason.
>

That's true. I'll make the change for git if Dave has no objections.

It happened because in the SGI tree we want it global for use in kdb by xfsidbg.o,
and that used to happen in the CONFIG_XFS_DEBUG case where STATIC would define
to nothing - looks like it is global always in our tree now since Dave's patch.
i.e. it was actually becoming global previously via STATIC on CONFIG_XFS_DEBUG
but one wouldn't have noticed that :) AFAICT.
Hmmm, I'll talk to Dave about this.

--Tim

> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>
> ---
> --- linux-2.6.20-mm2/fs/xfs/linux-2.6/xfs_buf.c.old	2007-02-18 22:55:40.000000000 +0100
> +++ linux-2.6.20-mm2/fs/xfs/linux-2.6/xfs_buf.c	2007-02-18 22:56:08.000000000 +0100
> @@ -1424,7 +1424,7 @@
>  /*
>   *	buftarg list for delwrite queue processing
>   */
> -LIST_HEAD(xfs_buftarg_list);
> +static LIST_HEAD(xfs_buftarg_list);
>  static DEFINE_SPINLOCK(xfs_buftarg_lock);
>
>  STATIC void
>
>




