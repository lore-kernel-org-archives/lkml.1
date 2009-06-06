Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbZFFVZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbZFFVZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 17:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZFFVZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 17:25:49 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:38793 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZFFVZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 17:25:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e64QbEQTWtwPGB9rE89GYSz8uKjYDUCq4keAVfhoo/OytLtW/uERsSQRpvzh/j0VmN
         QMwaL1+albinIBrzf2VbZDirL4cR1xySHU4Png8DQ9ZWuxrJayGChkkIVqVzCzuF9jJV
         O4n4O0o0+JSnVZZTxD1kYcC44uBTu1MpZ98e8=
MIME-Version: 1.0
In-Reply-To: <20090511192253.GH4694@kernel.dk>
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk>
Date: Sat, 6 Jun 2009 23:25:49 +0200
Message-ID: <c384c5ea0906061425x3b1ef6eer51d8a7ddeec51e47@mail.gmail.com>
Subject: Re: splice methods in character device driver
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Steve Rottinger <steve@pentek.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens,

in the spirit of splice-and-dice I continue asking questions until I grasp this.

On Mon, May 11, 2009 at 9:22 PM, Jens Axboe<jens.axboe@oracle.com> wrote:
> So if your design is allocating the pages in the ->splice_read()
> handler and initiating IO to these pages, then you need to provide a
> suitable ->confirm() hook that can wait on this IO to complete if
> needed.

When the driver's splice_read() is called, the kernel wants the driver to
allocate pages and later check that they are filled with data through the
confirm() hook. Is that correct?

How can I pass information from the splice_read(), which spawns a hardware
DMA to the pages in my case, to the confirm() hook which is called at some
(random) time in the future?

static int splice_read(struct file *in, loff_t *ppos,
struct pipe_inode_info *pipe, size_t len, unsigned int flags)

static int alt_pipe_buf_confirm(struct pipe_inode_info *pipe,
struct pipe_buffer *buf)


Regards,
-- 
Leon
