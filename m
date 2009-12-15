Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbZLOOQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbZLOOQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760333AbZLOOQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:16:19 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:34254 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760314AbZLOOQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:16:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=apwF0/BWk+CWJmhtPFP4hWHlb//CQcoWvs587xdL1B5hjgJnHTLHlsrpvWioZbe8X8
         3j9MvrxxibaSYL0sA2uAd7SxccphrprOGC/HaBVUt1BhSSlM9W10l5WGi2UglxQOQzrR
         V9OQ9KJs9AZYfVXvza5HBLilbMj44qJdacz3w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alexander Strakh <strakh@ispras.ru>
Subject: Re: BUG null dereference in driver ./drivers/net/3c507.c
Date: Tue, 15 Dec 2009 15:14:34 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Donald Becker <becker@scyld.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200912151755.08345.strakh@ispras.ru>
In-Reply-To: <200912151755.08345.strakh@ispras.ru>
MIME-Version: 1.0
Message-Id: <200912151514.34693.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 15 December 2009 06:55:08 pm Alexander Strakh wrote:
> 	KERNEL_VERSION: 2.6.32
> 	SUBJECT: null dereference aftre check
> 	DESCRIBE:
> 	In driver drivers/net/3c507.c in function Iirqreturn_t el16_interrupt:
> 
> 1. If in line 555 dev = NULL then we goto line 556
> 2. In line 556 we have null dereference because pr_err called with dev->name 
> in third parameter.
> 
>  555        if (dev == NULL) {
>  556                pr_err("%s: net_interrupt(): irq %d for unknown device.
> \n",
>  557                        dev->name, irq);
>  558                return IRQ_NONE;
>  559        }

There is no NULL dereference bug there possible since 'dev' will never be
actually NULL in el16_interrupt() (because of the way IRQ kernel subsystem
and 3c507 network driver are designed/work).

IOW it is just a bogus NULL pointer check, though it still would be nice
to have the issue fixed.  Care to send a patch removing it?

--
Bartlomiej Zolnierkiewicz
