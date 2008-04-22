Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbYDVVSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbYDVVSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbYDVVSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:18:14 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1556 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbYDVVSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:18:13 -0400
Subject: Re: [PATCH] hfs: if match_strdup() fails to allocate memory in
	parse_options(), don't blow up the kernel.
From: Joe Perches <joe@perches.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.00.0804222309250.14359@dragon.funnycrock.com>
References: <alpine.LNX.1.00.0804222309250.14359@dragon.funnycrock.com>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 14:17:24 -0700
Message-Id: <1208899044.8636.80.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 23:12 +0200, Jesper Juhl wrote:
> From: Jesper Juhl <jesper.juhl@gmail.com>
> diff --git a/fs/hfs/super.c b/fs/hfs/super.c
> index 32de44e..221e314 100644
> --- a/fs/hfs/super.c
> +++ b/fs/hfs/super.c
> @@ -297,6 +297,10 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
>  				return 0;
>  			}
>  			p = match_strdup(&args[0]);
> +			if (!p) {
> +				printk(KERN_ERR "hfs: mem alloc failed in match_strdup()\n");
> +				return 0;
> +			}
>  			hsb->nls_disk = load_nls(p);
>  			if (!hsb->nls_disk) {
>  				printk(KERN_ERR "hfs: unable to load codepage \"%s\"\n", p);
> @@ -311,6 +315,10 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
>  				return 0;
>  			}
>  			p = match_strdup(&args[0]);
> +			if (!p) {
> +				printk(KERN_ERR "hfs: memory allocation failed in match_strdup()\n");
> +				return 0;
> +			}
>  			hsb->nls_io = load_nls(p);
>  			if (!hsb->nls_io) {
>  				printk(KERN_ERR "hfs: unable to load iocharset \"%s\"\n", p);
> 

Using different strings in the printk wastes memory.

