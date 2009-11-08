Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbZKHQt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZKHQt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZKHQt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:49:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50021 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbZKHQt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:49:27 -0500
Date: Sun, 8 Nov 2009 11:49:13 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Hellwig <hch@infradead.org>,
       Daniel Pittman <daniel@rimspace.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Massive ext4 filesystem corruption after a failed
	s2disk/ram cycle
Message-ID: <20091108164913.GA12053@infradead.org>
References: <87vdisq7bh.fsf@rimspace.net> <20091007161604.GA28849@infradead.org> <20091104111125.54C3.A69D9226@jp.fujitsu.com> <20091108082905.GA25494@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108082905.GA25494@discord.disaster>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 07:29:05PM +1100, Dave Chinner wrote:
> We already have an ioctl that does what you want: FIFREEZE.

Doesn't really help as there is not guarentee important metadata is
modified again before the bootloader accesses it, but that's a fate
share with any other kind of super sync.  The only way to really fix
the problem is to implement proper (in-memory) log recovery in the
bootloader, especially as it doesn't only have to deal with the
relatively easy case of clean shutdowns but also needs to deal with the
case of an unclean shutdown with major amounts of updates to the lookup
and allocation data structures in the log.

IMHO the best option is to have a separate partition for /boot with a
very simple filesystem that we can expect boot loader developers to
implement fully and correctly.
