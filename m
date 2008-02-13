Return-Path: <linux-kernel-owner+w=401wt.eu-S932539AbYBMJfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbYBMJfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbYBMJeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:34:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57015 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832AbYBMJeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:34:44 -0500
Date: Wed, 13 Feb 2008 01:32:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Bart Dopheide <dopheide@fmf.nl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <mzolnier@gmail.com>
Subject: Re: Kernel BUG at fs/mpage.c:489
Message-Id: <20080213013255.b4ea534c.akpm@linux-foundation.org>
In-Reply-To: <200802132024.03687.nickpiggin@yahoo.com.au>
References: <20080212194546.GA2174@fmf.nl>
	<20080213072627.GB2174@fmf.nl>
	<20080213010145.76ee9714.akpm@linux-foundation.org>
	<200802132024.03687.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 20:24:03 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> BTW is it really true that the buffer can never be locked by
> anything else at this point?

It has been for the past five or six years.  With the page locked, nobody
else can get at that page.

> What about fsync_buffers_list?

They're metadata buffers, not regular file data.  Things might get ugly if
IO to /dev/sda went via that path, but it doesn't.

