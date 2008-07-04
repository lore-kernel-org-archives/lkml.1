Return-Path: <linux-kernel-owner+w=401wt.eu-S1760496AbYGDRFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760496AbYGDRFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756772AbYGDRFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 13:05:41 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45523 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754362AbYGDRFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:05:40 -0400
Subject: Re: [PATCH -mm] fix ipr-use-memory_read_from_buffer.patch
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Brian King <brking@us.ibm.com>
In-Reply-To: <20080704165438.GD22477@localhost.localdomain>
References: <200807040647.m646lXpN017508@imap1.linux-foundation.org>
	 <1215182555.5413.8.camel@localhost.localdomain>
	 <20080704163942.GA15214@localhost.localdomain>
	 <20080704165438.GD22477@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 12:05:36 -0500
Message-Id: <1215191136.5413.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-05 at 01:54 +0900, Akinobu Mita wrote:
> Now memory_read_from_buffer() belongs in string.h
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Brian King <brking@us.ibm.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/ipr.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: 2.6-mm/drivers/scsi/ipr.c
> ===================================================================
> --- 2.6-mm.orig/drivers/scsi/ipr.c
> +++ 2.6-mm/drivers/scsi/ipr.c
> @@ -71,6 +71,7 @@
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/libata.h>
> +#include <linux/string.h>
>  #include <asm/io.h>
>  #include <asm/irq.h>
>  #include <asm/processor.h>

This isn't really necessary, is it?  As you can see from the file being
stuffed full of memcpy directives, it's already getting an implicit
include of string.h from somewhere (like the rest of the SCSI drivers).

James


