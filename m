Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZFHBr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZFHBr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 21:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZFHBrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 21:47:48 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:63611 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZFHBrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 21:47:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=idoZcqlIAMR5r7oMBaSI4lSe7O5HdaM0YxRwMPSuB/+TynM9tKeFse37cORwf+uRBQ
         N7Ob5gJUu00bsZhGxurRFrLcmFemvnt1MwFJrl+F9JQDXeIATpzd6vD/o5TPmm5vFKEP
         xnQ1i5Ufq1W67O8NjwKWg72RERJsi3KyOZ1UM=
Date: Mon, 8 Jun 2009 09:50:18 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] proc: vmcore - use kzalloc in get_new_element
Message-ID: <20090608015018.GA2596@cr0.nay.redhat.com>
References: <20090606171207.GC20807@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090606171207.GC20807@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 09:12:07PM +0400, Cyrill Gorcunov wrote:
>Instead of kmalloc+memset better use straight kzalloc
>
>Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Looks good!

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>


>---
> fs/proc/vmcore.c |    7 +------
> 1 file changed, 1 insertion(+), 6 deletions(-)
>
>Index: linux-2.6.git/fs/proc/vmcore.c
>=====================================================================
>--- linux-2.6.git.orig/fs/proc/vmcore.c
>+++ linux-2.6.git/fs/proc/vmcore.c
>@@ -166,12 +166,7 @@ static const struct file_operations proc
> 
> static struct vmcore* __init get_new_element(void)
> {
>-	struct vmcore *p;
>-
>-	p = kmalloc(sizeof(*p), GFP_KERNEL);
>-	if (p)
>-		memset(p, 0, sizeof(*p));
>-	return p;
>+	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
> }
> 
> static u64 __init get_vmcore_size_elf64(char *elfptr)
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
