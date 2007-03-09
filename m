Return-Path: <linux-kernel-owner+w=401wt.eu-S1767422AbXCIRMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767422AbXCIRMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767426AbXCIRMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:12:41 -0500
Received: from smtp.nokia.com ([131.228.20.171]:48935 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767422AbXCIRMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:12:39 -0500
Message-ID: <45F19555.30904@yandex.ru>
Date: Fri, 09 Mar 2007 19:11:49 +0200
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Amit Choudhary <amit2030@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] fs/jffs2/scan.c: Fix error-path leak
References: <20070308232747.1605e81c.amit2030@gmail.com>
In-Reply-To: <20070308232747.1605e81c.amit2030@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Mar 2007 17:11:50.0562 (UTC) FILETIME=[06EF5020:01C7626E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please, do not forget look at MAINTAINERS and CC the maintainer. David is CCed.

Amit Choudhary wrote:
> Description: Fix error-path leak in function jffs2_scan_medium(), in file fs/jffs2/scan.c
> 
> Signed-off-by: Amit Choudhary <amit2030@gmail.com>
> 
> diff --git a/fs/jffs2/scan.c b/fs/jffs2/scan.c
> index e241346..cd9ed6e 100644
> --- a/fs/jffs2/scan.c
> +++ b/fs/jffs2/scan.c
> @@ -130,6 +130,8 @@ #endif
>  	if (jffs2_sum_active()) {
>  		s = kmalloc(sizeof(struct jffs2_summary), GFP_KERNEL);
>  		if (!s) {
> +			free(flashbuf);
> +			flashbuf = NULL;
>  			JFFS2_WARNING("Can't allocate memory for summary\n");
>  			return -ENOMEM;
>  		}
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
