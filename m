Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbYHVD2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbYHVD2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 23:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbYHVD1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 23:27:52 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:15070 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYHVD1w (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 23:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Vy3G9LptevU9OoI1pKrG+GXysAZxb0HC6Gs0UWlYIcCnHsErHpymvOzsi0vuRqpeWn
         AyIKoTwjej6K0mpXmM3OfjSirTq4pFpPGsLbQMhzWUNOdjATofMlAv4yEnY5t8chONhb
         +CF0gXoQqg6O/CkWgcuscSl1jHJB0CH5ioyS0=
Message-ID: <6934efce0808212027q412c4cbbp6ea8673a7d3bc1b9@mail.gmail.com>
Date: Thu, 21 Aug 2008 20:27:50 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Phillip Lougher" <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <48AE0697.5040706@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00F0.5030403@gmail.com> <48AE0697.5040706@lougher.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I assume compressed blocks can be larger than PAGE_CACHE_SIZE?  This suffers
> from the rather obvious inefficiency that you decompress a big block >
> PAGE_CACHE_SIZE, but only copy one PAGE_CACHE_SIZE page out of it.  If
> multiple files are being read simultaneously (a common occurrence), then
> each is going to replace your one cached uncompressed block
> (sbi->current_cnode_index), leading to decompressing the same blocks over
> and over again on sequential file access.
>
> readpage file A, index 1 -> decompress block X
> readpage file B, index 1 -> decompress block Y (replaces X)
> readpage file A, index 2 -> repeated decompress of block X (replaces Y)
> readpage file B, index 2 -> repeated decompress of block Y (replaces X)
>
> and so on.

Yep.  Been thinking about optimizing it.  So far it hasn't been an
issue for my customers.  Most fs traffic being on the XIP pages.  Once
I get a good automated performance test up we'll probably look into
something to improve this.
