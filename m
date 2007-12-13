Return-Path: <linux-kernel-owner+w=401wt.eu-S1761786AbXLMKda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761786AbXLMKda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758458AbXLMKdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:33:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51275 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758267AbXLMKdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:33:20 -0500
Subject: Re: 2.6.24-rc5 "videobuf_read_start"
	[drivers/media/video/videobuf-dvb.ko] undefined!
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Adrian Bunk <bunk@kernel.org>, Shane <gnome42@gmail.com>,
       Brandon Philips <brandon@ifup.org>, linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <20071212231944.53f09d99@hyperion.delvare>
References: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
	 <20071212090709.GF14204@stusta.de> <1197457394.4807.40.camel@gaivota>
	 <20071212120308.GG14204@stusta.de> <1197469316.4744.22.camel@gaivota>
	 <20071212231944.53f09d99@hyperion.delvare>
Content-Type: text/plain; charset=utf-8
Date: Thu, 13 Dec 2007 08:33:06 -0200
Message-Id: <1197541986.4729.24.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Em Qua, 2007-12-12 às 23:19 +0100, Jean Delvare escreveu:
> Hi Mauro,
> 
> On Wed, 12 Dec 2007 12:21:56 -0200, Mauro Carvalho Chehab wrote:
> > What happened is that changeset 19bc5133dae9562e8824ef101464061f9854c1d8
> > fixed some bad locks. 
> > 
> > After this changeset, videobuf_read_stream() holds q->lock and calls
> > videobuf_read_start(). To avoid waiting forever for the lock to be
> > released, he removed the mutex from videobuf_read_start with this line
> > [1]:
> > 
> > -       err = videobuf_mmap_setup(q, count, size, V4L2_MEMORY_USERPTR);
> > +       err = __videobuf_mmap_setup(q, count, size, V4L2_MEMORY_USERPTR);
> > 
> > So, after the patch, videobuf_read_start() can't be safely called. So,
> > just adding EXPORT_SYMBOL_GPL() breaks videobuf-dvb at runtime.
> > 
> > The proper solution is provided by this changeset:
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=19fb1457990b6b7e15586ec7331541a184233acc
> 
> There's a "static" missing in that patch: __videobuf_read_start is only
> used internally.

Thanks. It seems that I were not on my best day when I wrote this
patch....

Fixed.

-- 
Cheers,
Mauro

