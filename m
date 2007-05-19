Return-Path: <linux-kernel-owner+w=401wt.eu-S1761573AbXESGRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573AbXESGRZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 02:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbXESGRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 02:17:18 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:44984
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbXESGRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 02:17:17 -0400
From: Rob Landley <rob@landley.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] LogFS take three
Date: Sat, 19 May 2007 02:15:33 -0400
User-Agent: KMail/1.9.1
Cc: =?iso-8859-1?q?J=F6rn_Engel?= <joern@lazybastard.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
References: <20070515151919.GA32510@lazybastard.org> <20070515133759.9ee434a2.akpm@linux-foundation.org>
In-Reply-To: <20070515133759.9ee434a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <200705190215.36334.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2007 4:37 pm, Andrew Morton wrote:

> > +static inline struct logfs_super *LOGFS_SUPER(struct super_block *sb)
> > +{
> > +	return sb->s_fs_info;
> > +}
> > +
> > +static inline struct logfs_inode *LOGFS_INODE(struct inode *inode)
> > +{
> > +	return container_of(inode, struct logfs_inode, vfs_inode);
> > +}
> 
> Do these need to be uppercase?

I'm trying to keep it clear in my head...

When do you need to say __always_inline and when can you get away with just 
saying "static inline"?

(I'm attempting to write documentation on a topic I don't understand.  Best 
way to learn it, I've found...)

> > +     buf = kmap(page);
> > +     ret = logfs_write_buf(inode, index, buf);
> > +     kunmap(page);
>
> kmap() is lame.  The preferred approach would be to pass the page* down to
> the lower layers and to use kmap_atomic() at the lowest possible point.

Um, would I read about this in DMA-mapping.txt or cachetlb.txt?  (I don't 
think it's fujitsu/frv/mmu-layout.txt)

Rob
