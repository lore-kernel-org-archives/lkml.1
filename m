Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbYIOUTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbYIOUTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 16:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYIOUS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 16:18:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:49652 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbYIOUS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 16:18:57 -0400
Date: Tue, 16 Sep 2008 05:17:46 +0900
To: eo@nebensachen.de
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: Block: Trouble with kobject initialisation for blk_cmd_filter
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <87fxo1xjz0.fsf@denkblock.local>
References: <20080909214602L.fujita.tomonori@lab.ntt.co.jp>
	<20080909131850.GL20055@kernel.dk>
	<87fxo1xjz0.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080916051752H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2008 21:55:15 +0200
Elias Oltmanns <eo@nebensachen.de> wrote:

> >> Jens, would it be better to just disable the cmdfilter stuff for
> >> 2.6.27? It's too late for another try to fix this broken stuff, I
> >> guess.
> >
> > Yeah, it's certainly starting to look like it... The amount of changes
> > to unbreak it are too large to submit now, so lets postpone it until
> > 2.6.28.
> 
> As far as I can make out, nothing has happened yet at this front. I've
> just verified that reverting the following commits (in that order) seems
> to be working nicely for me:
> 
> 2dc75d3c3b4
> bb23b431db7
> a4a778971b9
> 4beab5c623f
> 14e507b852e
> abf54393704
> 06a452e5b95
> 2b272d4f795
> 0b07de85a76
> 
> Is that what you had in mind? Will you take care of it?

The following commit should disable the command filter feature:

commit 2dc75d3c3b49c64fd26b4832a7efb75546cb3fc5
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Thu Sep 11 14:20:23 2008 +0200

    block: disable sysfs parts of the disk command filter
