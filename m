Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbXGJXue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbXGJXue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbXGJXuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:50:25 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60040 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbXGJXuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:50:23 -0400
Subject: Re: [EXT4 set 2][PATCH 3/5] cleanups: set_jbd2_64bit_feature for
	>16TB ext4 fs
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
In-Reply-To: <20070710163022.333ece67.akpm@linux-foundation.org>
References: <1183275392.4010.122.camel@localhost.localdomain>
	 <20070710163022.333ece67.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 10 Jul 2007 16:50:24 -0400
Message-Id: <1184100624.3759.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 16:30 -0700, Andrew Morton wrote:
> On Sun, 01 Jul 2007 03:36:32 -0400
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
> > than 32bit block sizes during mount time.  This ensure proper record
> > lenth when writing to the journal.
> 
> This patch isn't in Ted's kernel.org directory and hasn't been in -mm. 
> Where did it come from?  Is something amiss with ext4 patch management?
> 
Jose Santo posted it to linux-ext4 mailing list.

I agree this bug fix should included in Ted's git tree or mm tree. There
are other ext4 cleanups in this series that should goes to mm tree also.

> > Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> > Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
> > ---
> >  fs/ext4/super.c |   11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > Index: linux-2.6.22-rc4/fs/ext4/super.c
> > ===================================================================
> > --- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-11 16:15:54.000000000 -0700
> > +++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-11 16:16:10.000000000 -0700
> > @@ -1804,6 +1804,13 @@
> 
> Please prepare patches using `diff -p'
> 

Will do.

> >  		goto failed_mount3;
> >  	}
> >  
> > +	if (ext4_blocks_count(es) > 0xffffffffULL &&
> > +	    !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0,
> > +				       JBD2_FEATURE_INCOMPAT_64BIT)) {
> > +		printk(KERN_ERR "ext4: Failed to set 64-bit journal feature\n");
> > +		goto failed_mount4;
> > +	}
> 
> It is not appropriate for the text "ext4" to appear in a JBD2 message.

This is part of ext4 code. Ext4 will set the 64-bit JBD2 flag if the fs
is larger than 32 bit blocks.

> >  	/* We have now updated the journal if required, so we can
> >  	 * validate the data journaling mode. */
> >  	switch (test_opt(sb, DATA_FLAGS)) {
> 
> 

