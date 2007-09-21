Return-Path: <linux-kernel-owner+w=401wt.eu-S1761995AbXIUSnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761995AbXIUSnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761899AbXIUSng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:43:36 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:43031 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761879AbXIUSne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:43:34 -0400
Date: Fri, 21 Sep 2007 12:44:00 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, trond.myklebust@fys.uio.no, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 3/5] VFS: pass open file to ->xattr()
Message-ID: <20070921184400.GQ32520@schatzie.adilger.int>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	hch@infradead.org, trond.myklebust@fys.uio.no,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20070921122343.307289079@szeredi.hu> <20070921123333.247493758@szeredi.hu> <20070921124323.GA8088@infradead.org> <E1IYi74-0001dX-00@dorka.pomaz.szeredi.hu> <20070921130642.GA9431@infradead.org> <E1IYiN2-0001eq-00@dorka.pomaz.szeredi.hu> <1190385151.6680.35.camel@heimdal.trondhjem.org> <20070921143427.GB14577@infradead.org> <E1IYjy8-0001lT-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IYjy8-0001lT-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 21, 2007  16:59 +0200, Miklos Szeredi wrote:
> What I'm saying is that read and write are _no_more_ related to the
> file than fstat.  Read/write operate on inode data, fstat operates on
> inode metadata.

The read and write operations are DEFINITELY related to the file descriptor
because of f_pos.  Each process opening the same file can have a different
f_pos so read/write will work in different locations of the file.

In contrast getattr and getxattr operate on the single inode and you don't
get e.g. a different i_size or i_uid or i_gid depending on who opened a
file, nor is the xattr different.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

