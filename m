Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbZKFLK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbZKFLK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 06:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbZKFLK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 06:10:57 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43726 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbZKFLK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 06:10:56 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: miklos@szeredi.hu, miklos@szeredi.hu, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, dhowells@redhat.com, hch@infradead.org,
       adilger@sun.com, mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, jamie@shareable.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20091105182548.07ca4bff@lxorguk.ukuu.org.uk> (message from Alan
	Cox on Thu, 5 Nov 2009 18:25:48 +0000)
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu>
	<20091105131545.72b4e319@lxorguk.ukuu.org.uk>
	<E1N63Io-000353-KX@pomaz-ex.szeredi.hu>
	<20091105145054.11f36b35@lxorguk.ukuu.org.uk>
	<E1N64Ch-0003C6-Rn@pomaz-ex.szeredi.hu>
	<20091105155648.4329f5b7@lxorguk.ukuu.org.uk>
	<E1N65Zt-0003L5-84@pomaz-ex.szeredi.hu> <20091105182548.07ca4bff@lxorguk.ukuu.org.uk>
Message-Id: <E1N6Mhx-0004s8-UU@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 06 Nov 2009 12:10:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, Alan Cox wrote:
> >  open O_RDONLY
> >  remote file moves
> >  new one appears
> >  fstat
> > 
> > What's the difference?
> 
> CIFS in the second case gets a handle to the remote object I believe. NFS
> certainly gets it right.

There's no f_op->fgetattr(), just i_op->getattr().

NFS gets it right, but NFSD is in the kernel and it can juggle with
looking up the inode by its number (for certain filesystems),
something CIFS is unlikely to be able to do.

Thanks,
Miklos
