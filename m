Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331Ab0AJILK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0AJILK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 03:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054Ab0AJILJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 03:11:09 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:50764 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab0AJILI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 03:11:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kwG8hsxQ9wJgxxmg4UG4hUdtHhkwbJjil+YHBisKL1vn1yXYt80/wCZKk13RwIvJA5
         i7InnnLl/MhdeFDJO/2E6N7rELzAWLCoeZPUWEGvJgVe4aMkk8uxkRLzJoGPqg5SapD7
         uYaH49xJmgr/8PAG6MjsWHChHWxcrz3wIYn4E=
Date: Sun, 10 Jan 2010 16:12:55 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uml: fix memory leak in arch/um/os-Linux/mem.c
Message-ID: <20100110081255.GB3005@hack>
References: <1263057984-12487-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263057984-12487-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 08:26:24PM +0300, Alexander Beregalov wrote:
>Free tempname before exit.
>Found by cppcheck.
>
>Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

>---
> arch/um/os-Linux/mem.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
>index 93a11d7..f079ea0 100644
>--- a/arch/um/os-Linux/mem.c
>+++ b/arch/um/os-Linux/mem.c
>@@ -175,7 +175,7 @@ static int __init make_tempfile(const char *template, char **out_tempname,
> 
> 	find_tempdir();
> 	if ((tempdir == NULL) || (strlen(tempdir) >= MAXPATHLEN))
>-		return -1;
>+		goto out;
> 
> 	if (template[0] != '/')
> 		strcpy(tempname, tempdir);
>-- 
>1.6.6
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
