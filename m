Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbYJNRdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbYJNRdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 13:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYJNRdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 13:33:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:53733 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYJNRdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 13:33:46 -0400
Message-ID: <48F4D769.9090702@kernel.org>
Date: Wed, 15 Oct 2008 02:31:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] block: add BIG FAT WARNING to	CONFIG_DEBUG_BLOCK_EXT_DEVT
References: <20081010205642.GA28840@elte.hu> <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org> <48EFF84B.5060108@kernel.org> <20081011071939.GA26465@elte.hu> <20081011140826.GS19428@kernel.dk> <20081011143355.GA6274@elte.hu> <20081011143947.GT19428@kernel.dk> <20081011145823.GA14062@elte.hu> <20081011175818.GY19428@kernel.dk> <48F2ED9F.7020606@kernel.org> <20081014151526.GA30205@infradead.org>
In-Reply-To: <20081014151526.GA30205@infradead.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Oct 2008 17:33:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Oct 13, 2008 at 03:41:35PM +0900, Tejun Heo wrote:
>> CONFIG_DEBUG_BLOCK_EXT_DEVT can break booting even on some modern
>> distros.  Add BIG FAT WARNING to keep people at a safe distance.
> 
> Just remove the whole "debug" code.  It clutters up all block drivers with
> ifdefs and doesn't actually provide any benefit.

Well, it's mostly intended for distros so that they can enable the
option and detect places where they assume consecutive minors as
otherwise most of those will go unnoticed until some user finally tries
to use more than 16 partitions.  As most distros are broken at the
moment, I'm more inclined to keep the debug option and planning on
enabling it during the next devel cycle of openSUSE and ask RH and other
distros to do the same.  It adds ifdefs to ide-disk and sd, which isn't
too much.  I think it would be good to keep it until at least distros
break out of the consecutive or fixed device number assumption.

Thanks.

-- 
tejun
