Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZFNByT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZFNByT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 21:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbZFNByD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 21:54:03 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:2315 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbZFNByB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 21:54:01 -0400
Date: Sat, 13 Jun 2009 22:52:40 -0300
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: Leandro Lucarella <llucax@gmail.com>
Cc: linux-kernel@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp,
       users@nilfs.org
Subject: Re: NILFS2 get stuck after bio_alloc() fail
Message-ID: <20090614015240.GW30412@blitiri.com.ar>
References: <20090614013211.GA22552@homero.springfield.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090614013211.GA22552@homero.springfield.home>
User-Agent: Mutt/1.5.17 (2008-03-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 10:32:11PM -0300, Leandro Lucarella wrote:
> Hi!
> 
> While testing nilfs2 (using 2.6.30) doing some "cp"s and "rm"s, I noticed
> sometimes they got stucked in D state, and the kernel had said the
> following message:
> 
>         NILFS: IO error writing segment
> 
> A friend gave me a hand and after adding some printk()s we found out that
> the problem seems to occur when bio_alloc()s inside nilfs_alloc_seg_bio()
> fail, making it return NULL; but we don't know how that causes the
> processes to get stucked.

By the way, those bio_alloc()s are using GFP_NOWAIT but it looks like they
could use at least GFP_NOIO or GFP_NOFS, since the caller can (and sometimes
do) sleep. The only caller is nilfs_submit_bh(), which calls
nilfs_submit_seg_bio() which can sleep calling wait_for_completion(). Is there
something I'm missing?

Thanks a lot,
		Alberto

