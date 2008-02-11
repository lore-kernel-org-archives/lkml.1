Return-Path: <linux-kernel-owner+w=401wt.eu-S1752212AbYBKFUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbYBKFUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 00:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYBKFUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 00:20:00 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:63127 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYBKFT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 00:19:58 -0500
Date: Sun, 10 Feb 2008 21:27:41 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] scsi: ses fix mem leaking when fail to add intf
In-reply-to: <1202704118.3136.79.camel@localhost.localdomain>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       kristen.c.accardi@intel.com
Message-id: <200802102127.42189.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802090413.53275.yinghai.lu@sun.com>
 <200802091515.48076.yinghai.lu@sun.com>
 <1202704118.3136.79.camel@localhost.localdomain>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008 08:28:38 pm James Bottomley wrote:
> 
> On Sat, 2008-02-09 at 15:15 -0800, Yinghai Lu wrote:
> > [PATCH] scsi: ses fix mem leaking when fail to add intf
> > 
> > fix leaking with scomp leaking when failing.
> > also remove one extra space.
> 
> There are still a few extraneous code moves in this one.  This is about
> the correct minimal set, isn't it?


if buf allocation for page 7 get NULL...

if put 
+ if (!buf)
+	goto err_free;

still not right, because still undo 
  	edev = enclosure_register(cdev->dev, sdev->sdev_gendev.bus_id,
 				  components, &ses_enclosure_callbacks);

all just add 
+ if (!buf)
+	goto simple_populate;

there?

YH
