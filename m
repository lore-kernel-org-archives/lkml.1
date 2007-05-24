Return-Path: <linux-kernel-owner+w=401wt.eu-S1751407AbXEXOqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbXEXOqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbXEXOqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:46:44 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:55029 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbXEXOqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Lj5A3GzMe6AesDlR+XdBaFkHppyvPpVIE71oh7kDYrbmVwJK8JI4vJTvAlB9QNbO9dzAeuUkTQHurRyVno4KyeY0DEBSUMkaWFm2yyaBwxS849ymEdulBPc7btyTy1oHc0NBk4N4N5+DE1dZ7g/Os/LhZWhRseli2eMn3jya5XI=
Subject: Re: [RFC 2/5] inode reservation v0.1 (ext4 kernel patch)
From: coly <colyli@gmail.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1180012837.11124.11.camel@kleikamp.austin.ibm.com>
References: <1179943606.4179.53.camel@coly-t43.site>
	 <1180012837.11124.11.camel@kleikamp.austin.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 24 May 2007 22:47:26 +0800
Message-Id: <1180018046.4078.2.camel@coly-t43.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Yes, I found all TABs gone when I received the mail. When I post next
version of the patch, I will test to send to me first :-)

Thanks for your information.

Coly


在 2007-05-24四的 08:20 -0500，Dave Kleikamp写道：
> On Thu, 2007-05-24 at 02:06 +0800, coly wrote:
> > The patch is generated based on 2.6.20-ext4-2 branch. you can find the
> > benchmark from other email.
> > 
> > DO NOT waste time on reading the patch :-) I post this patch here is to
> > show that I really spent time on it and the patch can work (even not
> > well).
> 
> I won't waste my time then.  I'm discouraged from trying by the lack of
> indentation.  It looks like the tabs got converted to a single space
> somehow.
> 
> > diff --git a/Makefile b/Makefile
> > index 7e2750f..21d21e4 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1,8 +1,7 @@
> > VERSION = 2
> > PATCHLEVEL = 6
> > SUBLEVEL = 20
> > -EXTRAVERSION =
> > -NAME = Homicidal Dwarf Hamster
> > +EXTRAVERSION = inores
> > 
> > # *DOCUMENTATION*
> > # To see a list of typical targets execute "make help"
> > diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
> > index 11e93c1..daf88b4 100644
> > --- a/fs/ext4/bitmap.c
> > +++ b/fs/ext4/bitmap.c
> > @@ -30,3 +30,29 @@ unsigned long ext4_count_free (struct buffer_head *
> > map, unsigned int numchars)
> > 
> > #endif  /*  EXT4FS_DEBUG  */
> > 
> > +/*
> > + * Read the inode allocation bitmap for a given block_group, reading
> > + * into the specified slot in the superblock's bitmap cache.
> > + *
> > + * Return buffer_head of bitmap on success or NULL.
> > + */
> > +struct buffer_head *
> > +read_inode_bitmap(struct super_block * sb, unsigned long block_group)
> > +{
> > + struct ext4_group_desc *desc;
> > + struct buffer_head *bh = NULL;
> > +
> > + desc = ext4_get_group_desc(sb, block_group, NULL);
> > + if (!desc)
> > + goto error_out;
> > +
> > + bh = sb_bread(sb, ext4_inode_bitmap(sb, desc));
> > + if (!bh)
> > + ext4_error(sb, "read_inode_bitmap",
> > + "Cannot read inode bitmap - "
> > + "block_group = %lu, inode_bitmap = %llu",
> > + block_group, ext4_inode_bitmap(sb, desc));
> > +error_out:
> > + return bh;
> > +}
> > +
> 
> Shaggy

