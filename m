Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbZBICyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbZBICyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 21:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZBICyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 21:54:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33750 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbZBICyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 21:54:43 -0500
Message-ID: <498F9AC2.2020703@sandeen.net>
Date: Sun, 08 Feb 2009 20:53:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Alessandro Bono <alessandro.bono@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@oss.sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
References: <1234011974.7435.11.camel@champagne.cantina>	<20090208222859.GA2532@infradead.org>	<1234132752.12370.0.camel@champagne.cantina>	<20090208224249.GA11931@infradead.org> <1234133120.12370.7.camel@champagne.cantina> <498F9A53.3090409@sandeen.net>
In-Reply-To: <498F9A53.3090409@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Alessandro Bono wrote:

..

>> sure, attached
> 
> Well, that seems to not be from the kernel you were running; there is no
> BUG() on line 470:
> 
> $ cat -n buffer.c | grep -8 "   470"
>    462				       bdevname(bh->b_bdev, b));
>    463			}
>    464			set_bit(AS_EIO, &page->mapping->flags);
>    465			set_buffer_write_io_error(bh);
>    466			clear_buffer_uptodate(bh);
>    467			SetPageError(page);
>    468		}
>    469	
>    470		first = page_buffers(page);

oh, oops :)  it's probably this BUG():

#define page_buffers(page)                                      \
        ({                                                      \
                BUG_ON(!PagePrivate(page));                     \


-Eric
