Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYKYKRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYKYKRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYKYKRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:17:20 -0500
Received: from mail2.shareable.org ([80.68.89.115]:54700 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbYKYKRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:17:19 -0500
Date: Tue, 25 Nov 2008 10:17:14 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Sachin Gaikwad <sachin.kernel@gmail.com>
Cc: Ric Wheeler <ric@emc.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20081125101714.GD1054@shareable.org>
References: <20080226072649.GB30238@shareable.org> <47C3C33F.1070908@garzik.org> <47C40269.7060309@emc.com> <20080226154315.GC18118@shareable.org> <f5524d840811241310m52fe0d30u2bcfaf3981f7368f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5524d840811241310m52fe0d30u2bcfaf3981f7368f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Gaikwad wrote:
> > No, fsync() doesn't always flush the drive's write cache.  It often
> > does, any I think many people are under the impression it always does,
> > but it doesn't.
> >
> > Try this code on ext3:
> >
> >        fd = open ("test_file", O_RDWR | O_CREAT | O_TRUNC, 0666);
> >        while (1) {
> >                char byte;
> >                usleep (100000);
> >                pwrite (fd, &byte, 1, 0);
> >                fsync (fd);
> >        }
> >
> > It will do just over 10 write ops per second on an idle system (13 on
> > mine), and 1 flush op per second.
> 
> How did you measure write-ops and flush-ops ? Is there any tool which
> can be used ? I tried looking at what CONFIG_BSD_PROCESS_ACCT
> provides, but no luck.

I don't remember; it was such a long time ago!

It probably involved looking at /sys/block/*/stat or something like that.

You might find the "blktrace" tool does what you want.

-- Jamie
