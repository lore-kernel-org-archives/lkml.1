Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbXHKGnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbXHKGnX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 02:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbXHKGnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 02:43:10 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58519 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbXHKGnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 02:43:07 -0400
Subject: Re: [PATCH] do not export /usr/include/scsi in make headers_install
From: David Woodhouse <dwmw2@infradead.org>
To: Olaf Hering <olh@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070806130210.GA2239@suse.de>
References: <20070806124546.GA2117@suse.de>
	 <20070806125212.GB12896@infradead.org>  <20070806130210.GA2239@suse.de>
Content-Type: text/plain
Date: Sat, 11 Aug 2007 14:42:50 +0800
Message-Id: <1186814570.3169.4.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 15:02 +0200, Olaf Hering wrote:
> On Mon, Aug 06, Christoph Hellwig wrote:
> 
> > On Mon, Aug 06, 2007 at 02:45:46PM +0200, Olaf Hering wrote:
> > > 
> > > glibc and make headers_install_all provide /usr/include/scsi
> > > One of them has to go.
> > > 
> > > A quick diff shows no differences, expect:
> > 
> > ..
> > 
> > > Which copy should be provided by a distributor?
> > 
> > The glibc one of course.  The kernel scsi.h should never have been
> > added to the list of exportable headers.  
> 
> /usr/include/scsi is provided by glibc.
> Remove the scsi export from make headers_install target.
> 
> 
> Signed-off-by: Olaf Hering <olh@suse.de>

Acked-by: David Woodhouse <dwmw2@infradead.org>

> ---
>  include/Kbuild      |    1 -
>  include/scsi/Kbuild |    4 ----
>  2 files changed, 5 deletions(-)
> 
> --- a/include/Kbuild
> +++ b/include/Kbuild
> @@ -1,6 +1,5 @@
>  header-y += asm-generic/
>  header-y += linux/
> -header-y += scsi/
>  header-y += sound/
>  header-y += mtd/
>  header-y += rdma/
> --- a/include/scsi/Kbuild
> +++ /dev/null
> @@ -1,4 +0,0 @@
> -header-y += scsi.h
> -
> -unifdef-y += scsi_ioctl.h
> -unifdef-y += sg.h
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
dwmw2

