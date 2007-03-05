Return-Path: <linux-kernel-owner+w=401wt.eu-S933602AbXCEVZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602AbXCEVZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933592AbXCEVZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:25:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44244 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933669AbXCEVZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:25:00 -0500
Date: Mon, 5 Mar 2007 16:24:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] aio: fix oops because of extra IO control block
 freeing.
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC8CA23F@mssmsx411>
Message-ID: <Pine.LNX.4.44L0.0703051619560.4040-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007, Ananiev, Leonid I wrote:

> 
> 
> >Where is kiocbSetPgBusy() defined,
> It is defined in include/linux/aio.h (introduced in [PATCH 1/3])
> >  and where in the documentation is it explained?
> I will add a comment for kiocbSetPgBusy()in aio.h.
> 
> > For that matter, what is the reason for changing the return value at
> all?
> EIORETRY is not IO return value at all. It is processing stage.
> It conflicts with IO return value. That is why a flag in iocb is used.
> It should be noted that loop but not EIOCBRETRY was used for vector IO
> (mm/filemap.c)

Okay.  But I don't like the name.  "kiocbSetPgBusy" might be meaningful to 
people who understand fs/aio.c, but it isn't meaningful to other people.

Could you add this to aio.h:

#define mark_iocb_not_complete(iocb)	kiocbSetPgBusy(iocb)

That would be a lot easier to understand.

Alan Stern


