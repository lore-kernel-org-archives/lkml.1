Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbXCPHWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbXCPHWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXCPHWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:22:01 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:23774 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752984AbXCPHWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:22:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=EgduLFMeUyFLlKxAt56vBYZmFZUlIYICvnYxuMyrQ5MY8J9lbDs79V0B/owUGadQ0H6kyQ2JtBqFG+SwE3cV0nJhpG/vNO60VlWBQPhHTgOxl/9/zY0rc7pwMg11n5/3r/DGqO++84Nxkrb+CtGDUL48GqRh5vHNLNo+GW5EXMg=  ;
X-YMail-OSG: z_acJGkVM1kvsdwSzjaH1ptlAibZhOQZxVRz4bjbTgRhjCnjtrzy8yy9o8cEKU7bivVXvx51ug0jFAJDa4YsW_q56HngaSFysP71rIFDkIxctn24st7dBWWFzfcYOG2GaYHH2mJQj1Zg1e4-
Message-ID: <45FA458C.8050605@yahoo.com.au>
Date: Fri, 16 Mar 2007 18:21:48 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] revoke: misc fixes
References: <Pine.LNX.4.64.0703160916430.14651@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0703160916430.14651@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This is a rollup patch of the following fixes to address some of Andrew's
> review comments:
> 
>   - Fix return value type of system calls to long
>   - Add comment for vma->vm_flag barrier
>   - No need for GFP_NOFS for inode allocation, use GFP_KERNEL instead
>   - Remove unnecessary line break before EXPORT_SYMBOL
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  fs/revoke.c              |    9 +++++----
>  include/linux/syscalls.h |    4 ++--
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> Index: uml-2.6/fs/revoke.c
> ===================================================================
> --- uml-2.6.orig/fs/revoke.c	2007-03-16 08:58:31.000000000 +0200
> +++ uml-2.6/fs/revoke.c	2007-03-16 09:00:37.000000000 +0200
> @@ -167,7 +167,9 @@ static int revoke_vma(struct vm_area_str
>  	end_addr = vma->vm_end;
>  
>  	/*
> - 	 * Not holding ->mmap_sem here.
> + 	 * Not holding ->mmap_sem here but we must watch out for page
> + 	 * faults and after the shared mappings have been taken down
> + 	 * and sys_mmap() trying to remap the revoked range.
>  	 */
>  	vma->vm_flags |= VM_REVOKED;
>  	smp_mb();
> @@ -455,7 +457,7 @@ 	int err = 0;

You're still modifying vm_flags without down_write mmap_sem, so this will
corrupt vm_flags.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
