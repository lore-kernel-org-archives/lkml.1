Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbZIHTrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbZIHTrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZIHTri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:47:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58585 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZIHTri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:47:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
Date: Tue, 8 Sep 2009 21:48:33 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com> <87ljkvmt71.fsf@devron.myhome.or.jp> <20090908190614.GA18545@lst.de>
In-Reply-To: <20090908190614.GA18545@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909082148.33872.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 September 2009, Christoph Hellwig wrote:
> On Fri, Sep 04, 2009 at 09:47:46AM +0900, OGAWA Hirofumi wrote:
> > Well, that commit seems a bit strange. It calls fat_clusters_flush()
> > unconditionally without checking sb->s_dirt. However, if my guess is
> > right, "sync after removed event" itself sounds like the issue in
> > suspend process.
> 
> The idea of ->sync_fs is that we always perform the sync activity,
> and not just the usual background superblock writeback trigerred by
> s_dirt.  If FAT doesn't need that and never has races around s_dirt
> you can add the check back, but I would recommend against it.
> 
> Also when you hack around this in FAt MMC will still fail with every
> other filesystem.

So, what should be done in your opinion?

Rafael
