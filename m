Return-Path: <linux-kernel-owner+w=401wt.eu-S1759838AbXH2TMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838AbXH2TMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbXH2TM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:12:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35018 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbXH2TM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:12:26 -0400
Date: Wed, 29 Aug 2007 20:12:25 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [patch 4/4] Switch to struct path in fs_struct
Message-ID: <20070829191225.GD28028@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
	John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
	Erez Zadok <ezk@cs.sunysb.edu>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
References: <20070808171622.632749741@suse.de> <20070808171643.542685765@suse.de> <20070808193209.GA31354@infradead.org> <20070810142208.827949199@suse.de> <20070810143847.174567467@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810143847.174567467@suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 04:22:12PM +0200, Andreas Gruenbacher wrote:
> * Move the definition of struct path into <linux/path.h>.
> 
> * Use struct path in fs_struct. This allows to use pathget and
>   pathput on a fs_struct.

Looks good.

Btw, WTF are pnpbios and sound looking at fs_struct?  They have no
right to poke there at all.

> --- /dev/null
> +++ b/include/linux/path.h
> @@ -0,0 +1,12 @@
> +#ifndef _LINUX_PATH_H
> +#define _LINUX_PATH_H
> +
> +struct dentry;
> +struct vfsmount;
> +
> +struct path {
> +	struct vfsmount *mnt;
> +	struct dentry *dentry;
> +};
> +
> +#endif  /* _LINUX_PATH_H */

This header should probably also have the prototypes for pathget/pathput

