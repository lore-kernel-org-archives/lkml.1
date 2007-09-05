Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbXIEPgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbXIEPgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXIEPgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:36:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:34832 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbXIEPgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:36:03 -0400
Date: Wed, 5 Sep 2007 08:35:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       brian@clusterfs.com
Subject: Re: patch: improve generic_file_buffered_write()
Message-Id: <20070905083529.a1c8a0a9.randy.dunlap@oracle.com>
In-Reply-To: <200709051546.06224.bs@q-leap.de>
References: <200709051546.06224.bs@q-leap.de>
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

On Wed, 5 Sep 2007 15:45:36 +0200 Bernd Schubert wrote:

> Hi,

meta-comments:

> filemap.c |  144 
> +++++++++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 96 insertions(+), 48 deletions(-)

Use "diffstat -p 1 -w 70" per Documentation/SubmittingPatches.


> Index: linux-2.6.20.3/mm/filemap.c
> ===================================================================
> --- linux-2.6.20.3.orig/mm/filemap.c	2007-09-04 13:43:04.000000000 +0200
> +++ linux-2.6.20.3/mm/filemap.c	2007-09-05 12:39:23.000000000 +0200
> @@ -2057,6 +2057,19 @@
>  }
>  EXPORT_SYMBOL(generic_file_direct_write);
>  
> +/**
> + * This function will do 3 main tasks for each iov:
> + * - prepare a write
> + * - copy the data from iov into a new page
> + * - commit this page
> + * @iob:	file operations
> + * @iov:	vector of data to write
> + * @nr_segs:	number of iov segments
> + * @pos:	position in the file
> + * @ppos:	position in the file after this function
> + * @count:	number of bytes to write
> + * written:	offset in iov->base (data to skip on write)
> + */
>  ssize_t
>  generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
>  		unsigned long nr_segs, loff_t pos, loff_t *ppos,

Use proper kernel-doc notation, per Documentation/kernel-doc-nano-HOWTO.txt.

This comment block should be:

/**
 * generic_file_buffered_write - handle an iov
 * @iocb:	file operations
 * @iov:	vector of data to write
 * @nr_segs:	number of iov segments
 * @pos:	position in the file
 * @ppos:	position in the file after this function
 * @count:	number of bytes to write
 * @written:	offset in iov->base (data to skip on write)
 *
 * This function will do 3 main tasks for each iov:
 * - prepare a write
 * - copy the data from iov into a new page
 * - commit this page
 */

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
