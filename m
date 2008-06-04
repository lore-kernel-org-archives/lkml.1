Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYFDEza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYFDEza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYFDEzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:55:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53725 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYFDEzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:55:19 -0400
To: mtk.manpages@googlemail.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@lst.de,
       miklos@szeredi.hu, viro@zeniv.linux.org.uk, jamie@shareable.org,
       drepper@redhat.com, linux-fsdevel@vger.kernel.org,
       subrata@linux.vnet.ibm.com
In-reply-to: <E1K3kkj-0007gR-Pb@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Wed, 04 Jun 2008 06:37:37 +0200)
Subject: Re: [parch 3/4] vfs: utimensat(): fix error checking for {UTIME_NOW,UTIME_OMIT}
 case
References: <4845C4CA.5070403@gmail.com> <E1K3kkj-0007gR-Pb@pomaz-ex.szeredi.hu>
Message-Id: <E1K3l1W-0007ia-Vc@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jun 2008 06:54:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	} else if ((times[0].tv_nsec == UTIME_NOW &&
> > +		    times[1].tv_nsec == UTIME_OMIT)
> > +		  ||
> > +		   (times[0].tv_nsec == UTIME_OMIT &&
> > +		    times[1].tv_nsec == UTIME_NOW)) {
> 

> +
> +		if (!is_owner_or_cap(inode))
> +			goto mnt_drop_write_and_out;

And in fact a little comment wouldn't hurt explaining what exactly is
going on here with the permission checking.

The "/* Don't worry, the checks are done in inode_change_ok() */" is
really reassuring, but unfortunately not exactly the truth (and never
was).

Miklos

