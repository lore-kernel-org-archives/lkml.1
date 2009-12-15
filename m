Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbZLOOVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbZLOOVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760375AbZLOOVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:21:50 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55676 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760358AbZLOOVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:21:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=Vm04XUDIpxua9hNzsDasLN0rewI8DEyYv2ab3hCgel1eFdb4rODKgM9nzwLXn4L4t0
         00+bFzj4z0ybh/+xOWVDV/HYONVwfA1OqgQARP4Uv9//WcInKwaSG/qm778WdIs2igTn
         zc/WwxamCuI2Tw/rmkX5hN9+XpL6Hue/Yu19c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alexander Strakh <strakh@ispras.ru>
Subject: Re: BUG null dereference in driver ./drivers/isdn/icn/icn.c
Date: Tue, 15 Dec 2009 15:20:48 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Fritz Elfert <fritz@isdn4linux.de>, Karsten Keil <isdn@linux-pingi.de>,
       Armin Schindler <mac@melware.de>, linux-kernel@vger.kernel.org
References: <200912151755.06796.strakh@ispras.ru>
In-Reply-To: <200912151755.06796.strakh@ispras.ru>
MIME-Version: 1.0
Message-Id: <200912151520.48798.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 December 2009 06:55:06 pm Alexander Strakh wrote:
> 	KERNEL_VERSION: 2.6.32
> 	SUBJECT: null dereference after check
> 	DESCRIBE:
> 	In driver ./drivers/isdn/icn/icn.c in function icn_addcard:
> 
> 1. If in line 1580 card2 = NULL  then we goto line 1581
> 2. In line 1581 we have null dereference because printk called with card2-
> >interface.id in third parameter.
> 
> 1580        if (!(card2 = icn_initcard(port, id2))) {
> 1581                printk(KERN_INFO
> 1582                       "icn: (%s) half ICN-4B, port 0x%x added\n",
> 1583                       card2->interface.id, port);
> 1584                return 0;
> 1585        }

After reading icn_addcard() it seems like the code was meant to use
'card' not 'card2' there.

--
Bartlomiej Zolnierkiewicz
