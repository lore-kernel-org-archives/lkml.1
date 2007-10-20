Return-Path: <linux-kernel-owner+w=401wt.eu-S1765021AbXJTQLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765021AbXJTQLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 12:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbXJTQLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 12:11:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38045 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbXJTQLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 12:11:31 -0400
Date: Sat, 20 Oct 2007 17:11:19 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@ftp.linux.org.uk>, Philip Langdale <philipl@overt.org>,
       Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] compat_ioctl: introduce generic_compat_ioctl helper
Message-ID: <20071020161119.GA22065@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@ftp.linux.org.uk>,
	Philip Langdale <philipl@overt.org>, Jiri Kosina <jkosina@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>
References: <47100864.2090208@overt.org> <20071013000221.GC8181@ftp.linux.org.uk> <200710201750.58521.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710201750.58521.arnd@arndb.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 05:50:57PM +0200, Arnd Bergmann wrote:
> Many drivers use only compatible ioctl numbers. In order to
> avoid having to write a special compat_ioctl handler for each
> of them or listing every ioctl number in fs/compat_ioctl.c,
> let's introduce a generic handler that simply calls the
> driver specific f_op->unlocked_ioctl() or f_op->ioctl() handler.

At least for the unlocked_ioctl case this is not nessecary because
the driver an simply set both the unlocked_ioctl and compat_ioctl
handlers to the same function.  For the drivers not using unlocked_ioctl
yet a function like this makes sense in theory, but I'd prefer to
just switch them to ->unlocked_ioctl.

