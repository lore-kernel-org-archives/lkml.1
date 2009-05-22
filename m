Return-Path: <linux-kernel-owner+w=401wt.eu-S1751590AbZEVJAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbZEVJAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbZEVJAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:00:25 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:48067 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbZEVJAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bvv34FG+PkCC965pOp87+W7gL4YzKlOvBs+zMYD75votn7jNZINkVSGFef0YfExzLS
         0kt+B2mjoBFx0RX/2TSrfx8s5JDxAgE1RepARbdx2WRDU8JVJXSJgU2fzxzAoU6aNM3h
         Qm5QRoZHPXW0ptGyctJwPigdxqpUqskrIvBh4=
Date: Fri, 22 May 2009 17:00:51 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, torvalds@linux-foundation.org,
       xemul@parallels.com, orenl@cs.columbia.edu, serue@us.ibm.com,
       dave@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [PATCH 03/38] ipcns 1/4: remove useless get/put while
	CLONE_NEWIPC
Message-ID: <20090522090051.GB22601@cr0.nay.redhat.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-3-git-send-email-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242968132-1044-3-git-send-email-adobriyan@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 08:54:57AM +0400, Alexey Dobriyan wrote:
>copy_ipcs() doesn't actually copy anything. If new ipcns is created, it's
>created from scratch, in this case get/put on old ipcns isn't needed.
>
>Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>Acked-by: Serge Hallyn <serue@us.ibm.com>


Looks good to me!

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>


>---
> ipc/namespace.c |    6 +-----
> 1 files changed, 1 insertions(+), 5 deletions(-)
>
>diff --git a/ipc/namespace.c b/ipc/namespace.c
>index 4a5e752..a56fc59 100644
>--- a/ipc/namespace.c
>+++ b/ipc/namespace.c
>@@ -50,15 +50,11 @@ struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
> {
> 	struct ipc_namespace *new_ns;
> 
>-	BUG_ON(!ns);
>-	get_ipc_ns(ns);
>-
> 	if (!(flags & CLONE_NEWIPC))
>-		return ns;
>+		return get_ipc_ns(ns);
> 
> 	new_ns = clone_ipc_ns(ns);
> 
>-	put_ipc_ns(ns);
> 	return new_ns;
> }
> 
>-- 
>1.5.6.5
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
