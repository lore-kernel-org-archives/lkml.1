Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbXFMSVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbXFMSVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759291AbXFMSVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:21:36 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:30578 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758951AbXFMSVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:21:35 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, akpm@osdl.org,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
In-Reply-To: <20070613175147.GB14355@suse.de>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613175147.GB14355@suse.de>
Content-Type: text/plain
Organization: IBM
Date: Wed, 13 Jun 2007 20:18:00 +0200
Message-Id: <1181758680.26375.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> Ick, why are you ignoring what we have already with dev_printk() and
> friends?  We are just finally getting developers to use that, I think it
> will be almost impossible to get people to change to something else,
> especially one that isn't even as "correct" as what dev_printk() offers
> you today, will be quite hard.
>
> So, why not use what we already have and work off of it?

dev_printk() and friends are great, since they already define something
like KMSG_COMPONENT: The driver name.

But they unfortunately do not solve our problem. We need an identifier
for a documented message in order to find the right description for a
message.

We could add new dev_printk macros for KMSG printks:

#define dev_printk_kmsg(kmsg, dev, format, arg...) \
        printk(kmsg "%s: " format , (dev)->bus_id , ## arg)
#define dev_err_kmsg(dev, nr, format, arg...) \
        dev_printk_kmsg(KMSG_ERR(nr) , dev , format , ## arg)

E.g. hub.c:
===========

#define KMSG_COMPONENT "hub"

dev_err_kmsg(&udev->dev, 1,
       "can't read configurations, error %d\n", err);

Which would result in:

hub.1 5-0:1.0: can't read configuration error 4711

Michael

