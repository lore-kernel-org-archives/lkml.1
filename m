Return-Path: <linux-kernel-owner+w=401wt.eu-S1762302AbYCUU5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302AbYCUU5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759103AbYCUU5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:57:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:50627 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702AbYCUU5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:57:35 -0400
Subject: Re: [SCSI] fix media change events for polled devices
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
In-Reply-To: <47E41DD3.2040602@garzik.org>
References: <200803211559.m2LFxPi6017869@hera.kernel.org>
	 <47E3EC67.4050404@garzik.org> <1206124426.24338.20.camel@lov.site>
	 <47E41DD3.2040602@garzik.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 21 Mar 2008 21:57:20 +0100
Message-Id: <1206133040.24338.30.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1/TgaJtTRSt+p+n+vuhqUgoepnDWu1uDdxPDjn
 TlZ/0xljH19ttoof/omn0ZORJ1V24pC8dVtWEk4qR/lG0VMoUZ
 XhNzqhyXEY5KDcBRSxomQgttw+sLtxI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-21 at 16:42 -0400, Jeff Garzik wrote:
> Kay Sievers wrote:
> > On Fri, 2008-03-21 at 13:12 -0400, Jeff Garzik wrote:
> >> Linux Kernel Mailing List wrote:


> >> When 285e9670 was updated for the scsi_evt_* interface, it should have 
> >> initialized the supported_events mask.
> >>
> >> And that is the fix -- initialize supported_events according to sr/sd's 
> >> needs, and revert this change (4d1566ed2100d074ccc654e5cf2e44cdea3a01d0) 
> >> as obviously broken.
> > 
> > You mean adding a new flag? As every device will "support" these events.
> 
> Does every device attached to every controller wish to fire these events?
> 
> If so, then that wants new flag, yes.

Yes, ﻿a new flag sounds good. Every device that detects a media change
should send such event, so userspace can possibly update it's
representation of the volume.
That way, userspace can switch to a single generic event, regardless if
the device is periodically polled, or supports AN.

Thanks,
Kay

