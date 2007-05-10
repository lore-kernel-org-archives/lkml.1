Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbXEJP4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbXEJP4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbXEJP4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:56:48 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:52846 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbXEJP4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:56:47 -0400
Message-ID: <4643401C.2080905@gmail.com>
Date: Thu, 10 May 2007 17:54:04 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Andrew Morton <akpm@osdl.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New Mitsumi legacy CD-ROM driver
References: <464045F0.3040906@gmail.com> <20070508103524.GH4163@kernel.dk> <46407D75.7050603@gmail.com> <20070508134944.GO4163@kernel.dk>
In-Reply-To: <20070508134944.GO4163@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2007 03:49 PM, Jens Axboe wrote:

> The key is that you have to have interrupts disabled for the highmem
> case, which may complicate your driver (or just make it perform worse,
> from the system POV). If you let the block layer bounce, then you can
> just use page_address() and don't worry about disabling interrupts.

Okay, yes, thank you, the mapping is gone. The data-transfer loop has now 
turned into just:

rq_for_each_bio(bio, req)
      bio_for_each_segment(bvec, bio, segno)
           ioread8_rep(mcd->ioaddr, page_address(bvec->bv_page) +
                       bvec->bv_offset, bvec->bv_len);

> - Or, it's a newer system and the nerd in you likes to play with ancient
>   CD-ROM drives.

And he has long since driven out most of my other personalities...

> Fine with me... As far as I am concerned, you are now the legacy CD-ROM
> driver maintainer :-)

Yippie :-)

Rene.

