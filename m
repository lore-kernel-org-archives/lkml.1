Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbZKQUrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbZKQUrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 15:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbZKQUrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 15:47:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:39929 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZKQUrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 15:47:14 -0500
Subject: Re: [PATCH 2/7] mmc: Don't use PF_MEMALLOC
From: Peter Zijlstra <peterz@infradead.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org
In-Reply-To: <4B029C40.2020803@gmail.com>
References: <20091117161711.3DDA.A69D9226@jp.fujitsu.com>
	 <20091117102903.7cb45ff3@lxorguk.ukuu.org.uk>
	 <20091117200618.3DFF.A69D9226@jp.fujitsu.com>  <4B029C40.2020803@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 21:47:06 +0100
Message-ID: <1258490826.3918.29.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 21:51 +0900, Minchan Kim wrote:
> I think it's because mempool reserves memory. 
> (# of I/O issue\0 is hard to be expected.
> How do we determine mempool size of each block driver?
> For example,  maybe, server use few I/O for nand. 
> but embedded system uses a lot of I/O. 

No, you scale the mempool to the minimum amount required to make
progress -- this includes limiting the 'concurrency' when handing out
mempool objects.

If you run into such tight corners often enough to notice it, there's
something else wrong.

I fully agree with ripping out PF_MEMALLOC from pretty much everything,
including the VM, getting rid of the various abuse outside of the VM
seems like a very good start.



