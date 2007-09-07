Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbXIGTRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbXIGTRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 15:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbXIGTRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 15:17:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22366 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758161AbXIGTQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 15:16:59 -0400
Date: Fri, 7 Sep 2007 12:15:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2][RESEND] improve generic_file_buffered_write()
Message-Id: <20070907121525.8a6dd582.randy.dunlap@oracle.com>
In-Reply-To: <200709072052.48396.bs@q-leap.de>
References: <200709072052.48396.bs@q-leap.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Sep 2007 20:52:38 +0200 Bernd Schubert wrote:

>  mm/filemap.c |  139 +++++++++++++++++++++++++++++++++----------------
>  1 file changed, 95 insertions(+), 44 deletions(-)
> 
>  
> Index: linux-2.6.23-rc5/mm/filemap.c
> ===================================================================
> --- linux-2.6.23-rc5.orig/mm/filemap.c	2007-09-06 18:33:11.000000000 +0200
> +++ linux-2.6.23-rc5/mm/filemap.c	2007-09-06 18:33:15.000000000 +0200
> @@ -1834,6 +1834,21 @@
>  }
>  EXPORT_SYMBOL(generic_file_direct_write);
>  

The kernel-doc still needs fixes as indicated below:

> +/**
> + * generic_file_buffered_write - handle iov'ectors
> + * @iob:	file operations

s/iob/iocb/

> + * @iov:	vector of data to write
> + * @nr_segs:	number of iov segments
> + * @pos:	position in the file
> + * @ppos:	position in the file after this function
> + * @count:	number of bytes to write
> + * written:	offset in iov->base (data to skip on write)

s/written/@written/

> + *
> + * This function will do 3 main tasks for each iov:
> + * - prepare a write
> + * - copy the data from iov into a new page
> + * - commit this page
> + */
>  ssize_t
>  generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
>  		unsigned long nr_segs, loff_t pos, loff_t *ppos,

Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
