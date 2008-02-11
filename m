Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYBKANT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYBKANT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 19:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYBKANL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 19:13:11 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:48799 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbYBKANK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 19:13:10 -0500
Date: Mon, 11 Feb 2008 01:13:09 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       davej@redhat.com
Subject: Re: [PATCH] make /dev/kmem a config option
In-Reply-To: <20080210155534.17fc6e5e@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0802110111160.7915@fbirervta.pbzchgretzou.qr>
References: <20080210155534.17fc6e5e@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 10 2008 15:55, Arjan van de Ven wrote:
>+#ifdef CONFIG_DEVKMEM
> /*
>  * This function reads the *virtual* memory as seen by the kernel.
>  */
>@@ -585,6 +588,11 @@ static ssize_t write_kmem(struct file * file, const char __user * buf,
>  	*ppos = p;
>  	return virtr + wrote;
> }
>+#else
>+#define read_kmem NULL
>+#define write_kmem NULL
>+#define mmap_kmem NULL
>+#endif

Is the #else case needed? All kmem_fops uses seem #ifdef'ed out anyway,
except kmem_fops itself. In other words,

+#ifdef CONFIG_DEVKMEM
 static const struct file_operations kmem_fops = {
 ...
 }
+#endif

and do away with the three defines. No? :)
