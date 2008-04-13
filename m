Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbYDMMHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbYDMMHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 08:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbYDMMHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 08:07:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:24395 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbYDMMHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 08:07:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rXW0/giP14p88q/uqtKA5rXKnsdTj8qf7NX9E3gzIjTfxjYLKbvGkSAG8PWr4e7Z11gZGJuopxq1bYLE037BmqB0wlq/ch0aRR/BDCbDNs/tyN2GuVasjxnSB9XiO2pX8StiQl1RxBOYLXLKCU7EunY4+a+8K8Nle5fh8+XkxKY=
Date: Sun, 13 Apr 2008 16:06:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UDF - use UDF_MAX_WRITE_VERSION instead of numbers
Message-ID: <20080413120622.GA7670@cvg>
References: <20080412194008.GB8388@cvg> <20080413115025.GA6488@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413115025.GA6488@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Marcin Slusarz - Sun, Apr 13, 2008 at 01:50:29PM +0200]
| On Sat, Apr 12, 2008 at 11:40:08PM +0400, Cyrill Gorcunov wrote:
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > ---
| > 
| > Jan, the patch is over current yours for_mm branch
| > 
| > Yep, i know it exceeds 80 column *but* it looks much better
| > in this way ;)
| > 
| > Index: linux-2.6.git/fs/udf/inode.c
| > ===================================================================
| > --- linux-2.6.git.orig/fs/udf/inode.c	2008-04-12 22:53:15.000000000 +0400
| > +++ linux-2.6.git/fs/udf/inode.c	2008-04-12 23:34:28.000000000 +0400
| > @@ -1732,7 +1732,7 @@ int8_t udf_add_aext(struct inode *inode,
| >  		}
| >  		if (epos->bh) {
| >  			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
| > -			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
| > +			    UDF_SB(inode->i_sb)->s_udfrev >= UDF_MAX_WRITE_VERSION)
| >  				udf_update_tag(epos->bh->b_data, loffset);
| >  			else
| >  				udf_update_tag(epos->bh->b_data,
| I think this patch is wrong. Right now it doesn't change anything, but in future
| when someone will add support for writing UDF > 2.01 (and bump UDF_MAX_WRITE_VERSION)
| it will break for filesystems written with udfrev >= 2.01 && udfrev < UDF_MAX_WRITE_VERSION.
| 
| Marcin
| 

well, if someone add support the writting UDF > 2.01 it will require
additional switches/analisys anyway and saving these hard-coded-numbers
would not help.

		- Cyrill -
