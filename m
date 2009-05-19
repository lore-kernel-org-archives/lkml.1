Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZESOFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZESOFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbZESOFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:05:39 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54708 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbZESOFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:05:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Tue, 19 May 2009 10:05:32 -0400
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 30/32] union mount: ext2 fallthru support
In-reply-to: <20090519094220.GI16526@bolzano.suse.de>
To: Jan Blunck <jblunck@suse.de>
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Message-id: <20090519140532.GB8138@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
 <1242662968-11684-31-git-send-email-jblunck@suse.de>
 <20090518163221.GE3144@webber.adilger.int>
 <20090519094220.GI16526@bolzano.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 19, 2009  11:42 +0200, Jan Blunck wrote:
> On Mon, May 18, Andreas Dilger wrote:
> > For enums like this that require specific constant on-disk values
> > I prefer being safe:
> > 
> > enum {
> > 	EXT2_FT_UNKNOWN  = 0,
> > 	EXT2_FT_REG_FILE = 1,
> > 	EXT2_FT_DIR	 = 2,
> > 	EXT2_FT_CHRDEV   = 3,
> > 	EXT2_FT_BLKDEV   = 4,
> > 	EXT2_FT_FIFO     = 5,
> > 	EXT2_FT_SOCK     = 6,
> > 	EXT2_FT_SYMLINK  = 7,
> > 	EXT2_FT_WHT      = 8,
> > 	EXT2_FT_FALLTHRU = 9,
> >  	EXT2_FT_MAX
> > 
> > 
> > It probably also makes sense to include a patch for ext3/ext4 to ensure
> > these values are not used by some unrelated feature.
> 
> In ext3 these are preprocessor defines. IIRC defines and enums are identical
> for C (both an int) so I leave this untouched and just add the new filetypes,
> right?

The problem is - what happens if, for whatever reason, EXT2_FT_WHT is
removed?  In a regular enum EXT2_ET_FALLTHRU would get the old value for
EXT2_FT_WHT (=8).  Alternately, if someone accidentally adds a value
before EXT2_FT_WHT because this isn't in the upstream e2fsprogs[*] and
this would push the values of EXT2_FT_WHT and EXT2_FT_FALLTHROUGH up.

That is why, when using enums for on-disk or "external" interfaces, I
prefer that the values are explicitly specified.  It also makes it more
clear when reading the code that these values are static and should not
be changed, instead of just a grouping of related constants.


[*] should be the canonical resource for new on-disk assignments, IMHO

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

