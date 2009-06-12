Return-Path: <linux-kernel-owner+w=401wt.eu-S1763098AbZFLIh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763098AbZFLIh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762746AbZFLIhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:37:32 -0400
Received: from lucidpixels.com ([75.144.35.66]:50717 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762886AbZFLIha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:37:30 -0400
Date: Fri, 12 Jun 2009 04:37:32 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Felix Blyakher <felixb@sgi.com>
cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many
 processes
In-Reply-To: <96F5FBF8-17B6-4AA9-BAB4-377AF596692C@sgi.com>
Message-ID: <alpine.DEB.2.00.0906120420080.26259@p34.internal.lan>
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan> <alpine.DEB.2.00.0906111255280.6809@p34.internal.lan> <4A313F84.20900@sandeen.net> <96F5FBF8-17B6-4AA9-BAB4-377AF596692C@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Felix Blyakher wrote:

>
> On Jun 11, 2009, at 12:31 PM, Eric Sandeen wrote:
>
>> Justin Piszcz wrote:
>>> 
>>> On Thu, 11 Jun 2009, Justin Piszcz wrote:
>>> 
> The following should fix it:
>
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 4b0f6ef..7928b99 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -6086,6 +6086,7 @@ xfs_getbmap(
>                      break;
>      }
>
> +       kmem_free(out);
>      return error;
> }
>
>
> Felix

Just FYI if anyone tries to run the patch it will not work:

# patch -p1 < ../xfs.patch 
patching file fs/xfs/xfs_bmap.c
patch: **** malformed patch at line 11: }

So just goto line ~6086 and add the kmem_free(out); above the return 
error.

Status:
This patch fixes the problem, thanks!

Justin.

