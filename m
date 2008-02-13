Return-Path: <linux-kernel-owner+w=401wt.eu-S932799AbYBMJjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbYBMJjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYBMJjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:39:42 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:23719 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751849AbYBMJjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:39:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HwWUIedNcdaxuBXNnByoPq6coPTKdd3aAvx7Nz2t4psJhDFKjAkb8yBHyfa9O2ymXswp1UQ0mWjI3NGDU0MRT4TsM2Sen+O5kMjWsTRrI/iagCHyEvNNU9yXwYjgrE7Vr3zBdPziAwJx/O5YwrzkGiwn0FeSvgGu5zF4C1L7KH8=  ;
X-YMail-OSG: .RrWlp4VM1n3zmfej4stOuZmRn11YtZpSpsYwq8st1kFAgvFQw3EegKDsC.aQyaoJI1GwwdUkw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Kernel BUG at fs/mpage.c:489
Date: Wed, 13 Feb 2008 20:39:25 +1100
User-Agent: KMail/1.9.5
Cc: Bart Dopheide <dopheide@fmf.nl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <mzolnier@gmail.com>
References: <20080212194546.GA2174@fmf.nl> <200802132024.03687.nickpiggin@yahoo.com.au> <20080213013255.b4ea534c.akpm@linux-foundation.org>
In-Reply-To: <20080213013255.b4ea534c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802132039.26169.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008 20:32, Andrew Morton wrote:
> On Wed, 13 Feb 2008 20:24:03 +1100 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > BTW is it really true that the buffer can never be locked by
> > anything else at this point?
>
> It has been for the past five or six years.  With the page locked, nobody
> else can get at that page.

Hmm OK.


> > What about fsync_buffers_list?
>
> They're metadata buffers, not regular file data.  Things might get ugly if
> IO to /dev/sda went via that path, but it doesn't.

Yeah right... so the BUG_ON is basically because you want to avoid
the overhead of locking the buffer (which would presumably allow it
to work in situations where someone else might lock the buffer without
locking the page?). OK, makes sense.
