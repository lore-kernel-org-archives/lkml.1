Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbXHFK7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbXHFK7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXHFK7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:59:47 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:56191 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbXHFK7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:59:46 -0400
To: ioe-lkml@rameria.de
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <200708041341.16231.ioe-lkml@rameria.de> (message from Ingo Oeser
	on Sat, 4 Aug 2007 13:41:15 +0200)
Subject: Re: [patch 03/11] fuse: add reference counting to fuse_file
References: <20070803174425.998083527@szeredi.hu> <20070803174918.484417699@szeredi.hu> <200708041341.16231.ioe-lkml@rameria.de>
Message-Id: <E1II0Is-0003oA-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Aug 2007 12:59:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Friday 03 August 2007, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Make lifetime of 'struct fuse_file' independent from 'struct file' by
> > adding a reference counter and destructor.
> 
> What about using krefs to implement that?

Thanks for the suggestion.  I'm aware of kref, but I don't see the
huge advantage over using the raw atomic interface.

> This will also fix the missing smp_barriers,

Why are the barriers needed?  The documentation doesn't say anything
about that.

> is very simple, saves code, makes your life easier and is a well
> known known kernel infrastructure :-)

I think it saves one line, and adds another, for a total of zero lines
saved ;)

Thanks,
Miklos
