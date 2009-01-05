Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbZAECvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbZAECvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZAECva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:51:30 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:44077
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbZAECv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:51:28 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: document ext3 requirements
Date: Sun, 4 Jan 2009 20:51:13 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <fa.P4z5CJpM0xT37PWJuOuCHDkO76o@ifi.uio.no> <fa.26o5IHCAC3TQdXupl62CLYwQ+Wk@ifi.uio.no> <49614284.8040201@yahoo.com>
In-Reply-To: <49614284.8040201@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042051.14269.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009 17:13:08 Sitsofe Wheeler wrote:
> Pavel Machek wrote:
> > Is there linux filesystem that can handle that? I know jffs2, but
> > that's unsuitable for stuff like USB thumb drives, right?
>
> This raises the question that if nothing can handle it which FS is the
> least bad? The last I heard people were saying that with cheap SSDs the
> recommendation was FAT [1] but in the future btrfs, nilfs and logfs
> would be better.
>
> [1] http://lkml.org/lkml/2008/10/14/129

I wonder if the flash filesystems could be told via mount options that they're 
to use a normal block device as if it was a flash with granularity X?

They can't explicitly control erase, but writing to any block in a block group 
will erase and rewrite the whole group so they can just do large write 
transactions close to each other and the device should aggregate enough for an 
erase block.  (Plus don't touch anything _outside_ where you guess an erase 
block to be until you've finished writing the whole block, which they 
presumably already do.)

The other question is whether there's any way to guess an erase granularity 
that's "good enough" for a device of size X, maybe larger than the device 
actually does but not smaller than any remotely sane manufacturer would 
implement.  (And just _don't_ partition these suckers, so you don't have to 
worry about partitions aligning with erase block sizes.) 

Rob
