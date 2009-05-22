Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZEVI7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZEVI7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZEVI7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:59:00 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:56556 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZEVI67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bkcJMRD4nBfZamiM1KOAyVnT8UU/6mGE/y0ApHbPdLzO+CbiXHDMyphB+oM06W8TBX
         zIJVUANOy+TYZg6BH7fx7qXr66iDFKsmXtqjBBibpwNCaWjca9kEyUgQCsIz0m63fOsJ
         zssUu6NHEcyVMBvYx5wkvWPvLGfwuAp4CzoPc=
Date: Fri, 22 May 2009 16:59:24 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, torvalds@linux-foundation.org,
       xemul@parallels.com, orenl@cs.columbia.edu, serue@us.ibm.com,
       dave@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [PATCH 04/38] ipcns 2/4: extract create_ipc_ns()
Message-ID: <20090522085924.GA22601@cr0.nay.redhat.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-4-git-send-email-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242968132-1044-4-git-send-email-adobriyan@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 08:54:58AM +0400, Alexey Dobriyan wrote:
>clone_ipc_ns() is misnamed, it doesn't clone anything and doesn't use passed
>parameter. Rename it.
>
>create_ipc_ns() will be used by C/R to create fresh ipcns.
>
>Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>Acked-by: Serge Hallyn <serue@us.ibm.com>
>---
> ipc/namespace.c |    9 ++-------
> 1 files changed, 2 insertions(+), 7 deletions(-)
>
>diff --git a/ipc/namespace.c b/ipc/namespace.c
>index a56fc59..231ee53 100644
>--- a/ipc/namespace.c
>+++ b/ipc/namespace.c
>@@ -14,7 +14,7 @@
> 
> #include "util.h"
> 
>-static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
>+static struct ipc_namespace *create_ipc_ns(void)


Great!! I am wondering why nobody else found this... :)

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>



> {
> 	struct ipc_namespace *ns;
> 	int err;
>@@ -48,14 +48,9 @@ static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
> 
> struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
> {
>-	struct ipc_namespace *new_ns;
>-
> 	if (!(flags & CLONE_NEWIPC))
> 		return get_ipc_ns(ns);
>-
>-	new_ns = clone_ipc_ns(ns);
>-
>-	return new_ns;
>+	return create_ipc_ns();
> }
> 
> /*
>-- 
>1.5.6.5
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
