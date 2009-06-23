Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZFWRGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZFWRGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZFWRGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:06:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33347 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZFWRGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:06:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <E1MJ8u3-00083c-TD@pomaz-ex.szeredi.hu>
References: <E1MJ8u3-00083c-TD@pomaz-ex.szeredi.hu> <20090623170610.7fd8a3f8@lxorguk.ukuu.org.uk> <E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu> <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <20090623134640.GA13831@infradead.org> <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu> <20090623143408.GA2147@infradead.org> <16370.1245772337@redhat.com> <16755.1245773452@redhat.com> 
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, alan@lxorguk.ukuu.org.uk, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk, adilger@sun.com,
       akpm@linux-foundation.org
Subject: Re: [RFC] O_NOACC: open without any access
Date: Tue, 23 Jun 2009 18:05:20 +0100
Message-ID: <17310.1245776720@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> So how about the following: provide a new open flag O_FILESYSTEM,
> meaning it opens the file on the underlying filesystem instead of the
> device/socket/symlink/etc...

Yes.  That's what I need.  That's what pioctl() is for: it operates on the
underlying fs, not any special aspects of the various types of file, and since
it doesn't do traditional I/O on those files, it doesn't need to, and
shouldn't, open them (thus avoiding side effects from ->open()), and doesn't
need R/W access to them.

> Add a new inode->i_filesystem_fop pointer

I'd rather not put it there.  That means the inode struct grows.  Perhaps
attach it to the inode_operations table or stick an open_noaccess() op in the
iops table.

> Define O_NOACC as 3.  On open(..., O_FILESYSTEM | O_NOACC) require no
> privileges on the file.

It must also work with O_NOFOLLOW, which I think your suggestion will.

> AFS would set up i_filesystem_fop with its ->ioctl() function. No
> special handling needed for revoke()...

Sounds reasonable.

> That would work, no?

I think so.

David
