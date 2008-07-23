Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYGWNYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYGWNYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 09:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYGWNYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 09:24:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:42152 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYGWNYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 09:24:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U2eGXdewzJFM61XZyn44l118YvtxOp3L4yFsFFLLtquryNsezmzp1tKyNoz2IL8gJ1
         cuIkvboatWJwR7T9gwR9ITvuUaEC/cwjtXWYsLj5ipRAoceB/xaYU8fWxf245Zm8l9p3
         1+XcUZbYYLSKzaG//+jQUQ1pZbVj0QcHrzCdk=
Date: Wed, 23 Jul 2008 17:23:40 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrei Popa <andrei.popa@i-neo.ro>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de
Subject: [PATCH] cdc-acm: don't unlock acm->mutex on error path
Message-ID: <20080723132310.GB4894@martell.zuzino.mipt.ru>
References: <1216817556.4415.29.camel@ierdnac>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216817556.4415.29.camel@ierdnac>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 03:52:36PM +0300, Andrei Popa wrote:
> I installed gnokii-0.6.22-r2 and gave the command "gnokii --identify"
> and the kernel oopsed:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000458
> IP: [<c0444b52>] mutex_unlock+0x0/0xb
>  [<c03830ae>] acm_tty_open+0x4c/0x214

Try this:

[PATCH] cdc-acm: don't unlock acm->mutex on error path

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/usb/class/cdc-acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -595,8 +595,8 @@ static int acm_tty_open(struct tty_struct *tty, struct file *filp)
 	tasklet_schedule(&acm->urb_task);
 
 done:
-err_out:
 	mutex_unlock(&acm->mutex);
+err_out:
 	mutex_unlock(&open_mutex);
 	return rv;
 

