Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbYBKAms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbYBKAms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 19:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYBKAmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 19:42:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34070 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbYBKAmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 19:42:39 -0500
Date: Sun, 10 Feb 2008 16:42:05 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       davej@redhat.com
Subject: Re: [PATCH] make /dev/kmem a config option
Message-ID: <20080210164205.3d8f6680@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0802110111160.7915@fbirervta.pbzchgretzou.qr>
References: <20080210155534.17fc6e5e@laptopd505.fenrus.org>
	<Pine.LNX.4.64.0802110111160.7915@fbirervta.pbzchgretzou.qr>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 01:13:09 +0100 (CET)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Feb 10 2008 15:55, Arjan van de Ven wrote:
> >+#ifdef CONFIG_DEVKMEM
> > /*
> >  * This function reads the *virtual* memory as seen by the kernel.
> >  */
> >@@ -585,6 +588,11 @@ static ssize_t write_kmem(struct file * file,
> >const char __user * buf,
> >  	*ppos = p;
> >  	return virtr + wrote;
> > }
> >+#else
> >+#define read_kmem NULL
> >+#define write_kmem NULL
> >+#define mmap_kmem NULL
> >+#endif
> 
> Is the #else case needed? All kmem_fops uses seem #ifdef'ed out
> anyway, except kmem_fops itself. In other words,
> 
> +#ifdef CONFIG_DEVKMEM
>  static const struct file_operations kmem_fops = {
>  ...
>  }
> +#endif
> 
> and do away with the three defines. No? :)

hmm I tried that first, and didn't work
but that wasn't on the final version of the patch so let me try again..


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
