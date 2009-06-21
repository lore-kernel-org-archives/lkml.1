Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbZFULIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbZFULIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 07:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZFULIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 07:08:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53375 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbZFULIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 07:08:43 -0400
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
cc: linux-kernel@vger.kernel.org, users@nilfs.org
Subject: Re: [PATCH] nilfs2: fix hang problem after bio_alloc() failed
From: Andi Kleen <andi@firstfloor.org>
References: <20090614153256.GA4020@homero.springfield.home>
	<20090615.030245.104791670.konishi.ryusuke@gmail.com>
	<20090614181313.GA16597@homero.springfield.home>
	<20090619.023455.111674749.ryusuke@osrg.net>
Date: Sun, 21 Jun 2009 13:08:43 +0200
In-Reply-To: <20090619.023455.111674749.ryusuke@osrg.net> (Ryusuke Konishi's message of "Fri, 19 Jun 2009 02:34:55 +0900 (JST)")
Message-ID: <87ocshvo78.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> writes:
>  
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 22c7f65..e8f188b 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -1846,26 +1846,13 @@ static int nilfs_segctor_write(struct nilfs_sc_info *sci,
>  		err = nilfs_segbuf_write(segbuf, &wi);
>  
>  		res = nilfs_segbuf_wait(segbuf, &wi);
> -		err = unlikely(err) ? : res;
> +		err = unlikely(err) ? err : res;

It's very dubious gcc does anything with unlikely here anyways.
They typically only work directly in conditions being tested.

>  		if (unlikely(err))
>  			return err;

Also gcc generally considers conditions to blocks that
return unlikely, so it's actually superfluous.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
