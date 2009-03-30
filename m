Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZC3MEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZC3MEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZC3MEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:04:09 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:52947 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbZC3MEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:04:08 -0400
Message-ID: <49D0B535.2010106@oss.ntt.co.jp>
Date: Mon, 30 Mar 2009 21:04:05 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 2/5] ext3: call blkdev_issue_flush on fsync()
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp>
In-Reply-To: <49D03377.1040909@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis Vázquez Cao wrote:
> Jeff Garzik wrote:
>> Fernando Luis Vázquez Cao wrote:
>>> To ensure that bits are truly on-disk after an fsync or fdatasync, we
>>> should force a disk flush explicitly when there is dirty data/metadata
>>> and the journal didn't emit a write barrier (either because metadata is
>>> not being synched or barriers are disabled).
>>>
>>> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
>>
>> Your patches do not seem to propagate the issue-flush error code, even 
>> when it is easily available.
> 
> Oops... you are right. I will fix that.

I reflected your comments in the new version of the patch set.While at 
it I also modified the respective reiserfs and xfs fsync functions so 
that, at least to some extent,they propagate the issue-flush error code.

I'll be replying to this email with the new patches.

Thanks,

Fernando
