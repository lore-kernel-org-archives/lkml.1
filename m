Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbXIASji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbXIASji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 14:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbXIASj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 14:39:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43805 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbXIASj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 14:39:26 -0400
Date: Sat, 1 Sep 2007 19:39:22 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mingming Cao <cmm@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, adilger@clusterfs.com, sho@tnes.nec.co.jp,
       ext4 development <linux-ext4@vger.kernel.org>,
       linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: [RFC 1/2] JBD: slab management support for large block(>8k)
Message-ID: <20070901183922.GA12907@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>, linux-fsdevel@vger.kernel.org,
	adilger@clusterfs.com, sho@tnes.nec.co.jp,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org, clameter@sgi.com
References: <20070828190551.415127746@sgi.com> <20070828190735.292638294@sgi.com> <1188432669.3799.35.camel@localhost.localdomain> <1188434857.3799.76.camel@localhost.localdomain> <1188605538.3837.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188605538.3837.51.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 05:12:18PM -0700, Mingming Cao wrote:
> >From clameter:
> Teach jbd/jbd2 slab management to support >8k block size. Without this, it refused to mount on >8k ext3.


But the real fix is to kill this code.  We can't send down slab pages
down the block layer without breaking iscsi or aoe.  And this code is
only used in so rare cases that all the normal testing won't hit it.
Very bad combination.
