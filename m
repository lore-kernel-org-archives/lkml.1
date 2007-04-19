Return-Path: <linux-kernel-owner+w=401wt.eu-S1766862AbXDSQjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766862AbXDSQjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766868AbXDSQjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:39:48 -0400
Received: from cobalt0.barnhard.net ([216.181.81.129]:38609 "EHLO
	cobalt0.barnhard.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766862AbXDSQjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:39:46 -0400
Date: Thu, 19 Apr 2007 17:39:30 +0100
From: Dale Amon <amon@vnl.com>
To: Dale Amon <amon@vnl.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Problem with ufs nextstep in 2.6.18 (debian)
Message-ID: <20070419163930.GA3901@vnl.com>
Mail-Followup-To: Dale Amon <amon@vnl.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070416073204.GA10225@rain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416073204.GA10225@rain>
X-Operating-System: Linux, the choice of a GNU generation
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 11:32:04AM +0400, Evgeniy Dushistov wrote:
> >The error also happens in 2.6.19, same as in 2.6.18.
> >I extracted this from syslog: 
> >Apr 17 00:14:15 kdev kernel: UFS-fs error (device loop0):
> >ufs_check_page: bad entry
> 
> Is this happened also with this patch:
> http://lkml.org/lkml/diff/2007/2/5/75/1
> ?
> 
> -- 
> /Evgeniy

I tried the patch but it would not apply to 2.6.20.7 and
appeared to already exist in that release as patch was
asking me about reversing the patch. So I just built a
vanilla version:

Linux otv2 2.6.20.7-i686 #1 SMP Tue Apr 17 02:33:19 BST 2007 i686 GNU/Linux

and then tried the mount again:

otv2:/dma/FloppyDisks-3.50# mount -t ufs -o ro,ufstype=nextstep,loop NeXT-Diagram1-fd0a.ufs /floppy
otv2:/dma/FloppyDisks-3.50# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/hda2              8649576   5141412   3068788  63% /
tmpfs                   128128         0    128128   0% /lib/init/rw
udev                     10240        60     10180   1% /dev
tmpfs                   128128         0    128128   0% /dev/shm
/dma/FloppyDisks-3.50/NeXT-Diagram1-fd0a.ufs
                          1255      1184        71  95% /media/floppy0
otv2:/dma/FloppyDisks-3.50# ls /floppy
ls: reading directory /floppy: Input/output error

I find in syslog:

Apr 19 17:34:29 localhost kernel: UFS-fs error (device loop0): ufs_check_page: bad entry in directory #2: directory entry across blocks - offset=140, rec_len=884, name_len=7
Apr 19 17:34:29 localhost kernel: UFS-fs error (device loop0): ufs_readdir: bad page in #2

I would be happy to supply you with an image of the NeXT /dev/fd0a
floppy partition if you would like, or even a full image of
the floppy made via the NeXT raw device /dev/rfd0b.





