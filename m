Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbXLLWT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbXLLWT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbXLLWTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:19:48 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:3532 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751147AbXLLWTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:19:47 -0500
Date: Wed, 12 Dec 2007 23:19:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, Shane <gnome42@gmail.com>,
       Brandon Philips <brandon@ifup.org>, linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>
Subject: Re: 2.6.24-rc5 "videobuf_read_start"
 [drivers/media/video/videobuf-dvb.ko] undefined!
Message-ID: <20071212231944.53f09d99@hyperion.delvare>
In-Reply-To: <1197469316.4744.22.camel@gaivota>
References: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
	<20071212090709.GF14204@stusta.de>
	<1197457394.4807.40.camel@gaivota>
	<20071212120308.GG14204@stusta.de>
	<1197469316.4744.22.camel@gaivota>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Wed, 12 Dec 2007 12:21:56 -0200, Mauro Carvalho Chehab wrote:
> What happened is that changeset 19bc5133dae9562e8824ef101464061f9854c1d8
> fixed some bad locks. 
> 
> After this changeset, videobuf_read_stream() holds q->lock and calls
> videobuf_read_start(). To avoid waiting forever for the lock to be
> released, he removed the mutex from videobuf_read_start with this line
> [1]:
> 
> -       err = videobuf_mmap_setup(q, count, size, V4L2_MEMORY_USERPTR);
> +       err = __videobuf_mmap_setup(q, count, size, V4L2_MEMORY_USERPTR);
> 
> So, after the patch, videobuf_read_start() can't be safely called. So,
> just adding EXPORT_SYMBOL_GPL() breaks videobuf-dvb at runtime.
> 
> The proper solution is provided by this changeset:
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=19fb1457990b6b7e15586ec7331541a184233acc

There's a "static" missing in that patch: __videobuf_read_start is only
used internally.

-- 
Jean Delvare
