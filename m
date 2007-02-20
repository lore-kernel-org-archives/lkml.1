Return-Path: <linux-kernel-owner+w=401wt.eu-S932941AbXBTNGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbXBTNGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932946AbXBTNGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:06:45 -0500
Received: from smtp.nokia.com ([131.228.20.171]:64781 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941AbXBTNGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:06:44 -0500
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070219105445.GA16930@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
	 <20070219105445.GA16930@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Feb 2007 15:05:53 +0200
Message-Id: <1171976753.4039.27.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Feb 2007 13:05:59.0463 (UTC) FILETIME=[DD927B70:01C754EF]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070220150403-18317BB0-099787E2/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 10:54 +0000, Christoph Hellwig wrote:
> On Sat, Feb 17, 2007 at 06:54:49PM +0200, Artem Bityutskiy wrote:
> > +#ifndef __UBI_UBI_H__
> > +#define __UBI_UBI_H__
> > +
> > +#include <linux/mtd/ubi.h>
> > +
> > +/* Version of this UBI implementation */
> > +#define UBI_VERSION 1
> We shouldn't have versions for inkernel interfaces.

What do you mean? It is internal version just for future help: if we
develop incompatible UBI2 the old UBI will reject the new images.

> > +/* UBI messages printk level */
> > +#define UBI_MSG_LEVEL  KERN_INFO
> > +#define UBI_WARN_LEVEL KERN_WARNING
> > +#define UBI_ERR_LEVEL  KERN_ERR
> 
> Please use the KERN_ macros directly.

Will be done, thanks.

> > +/* UBI error messages */
> > +#define ubi_err(fmt, ...)                                                   \
> > +	printk(UBI_ERR_LEVEL UBI_ERR_PREF " %s " fmt "\n", __FUNCTION__,    \
> > +	       ##__VA_ARGS__)
> 
> you should probably use dev_printk and the wrappers around it in most
> places.

I will look at it, thanks.

> > +extern int ubis_num;
> > +extern struct ubi_info *ubis[UBI_MAX_INSTANCES];
> 
> Having this kind of global information directly exposed is a very
> bad idea.  In general you only want to access it through more
> specific information and avoid allocating the global array at all.

I do not see what is the problem with this. Please, refine.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

