Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXBSOGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXBSOGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932264AbXBSOGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:06:09 -0500
Received: from smtp.nokia.com ([131.228.20.170]:46116 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbXBSOGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:06:08 -0500
Subject: Re: [PATCH 41/44 take 2] [UBI] gluebi unit header
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <200702182337.53314.arnd@arndb.de>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <200702180315.25067.arnd@arndb.de>
	 <20070218030217.GH1038@crusty.rchland.ibm.com>
	 <200702182337.53314.arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Feb 2007 15:52:15 +0200
Message-Id: <1171893135.13817.72.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Feb 2007 13:52:14.0941 (UTC) FILETIME=[297910D0:01C7542D]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070219154853-07F2EBB0-48397823/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-18 at 23:37 +0100, Arnd Bergmann wrote:
> Which brings be back to my original point ;-)
> 
> I'm sure this has been discussed before, but I'd still like to understand
> what is so special with 'static UBI volumes' that they can't be used with
> a slightly extended MTD interface.

Let me provide a list of new things.

* Two types of character devices: UBI devices and UBI volumes. MTD is
aware only of one type of device - just MTD device.
* Two types of volumes.
* New volume update operation.
* Write hints - you may inform UBI which kind of data you are writing -
long term data, short-term data, or just unknown. Depending on the hint
it will pick physical eraseblock with high erase counter low or medium.
* Asynchronous eraseblock erasure operation
* Atomic eraseblock change operation.
* When you read static volume, you may select whether you want UBI to
check CRC or not (CRCs are per-eraseblock, so often it is not reasonable
to check it on any read operation).
* Resizing of volume, and all the things related to their dynamic
nature.
* some other small new interfaces.

The whole idea of MTD interface it to provide _uniform_ method to access
_all_ flashes. It does not look reasonable for UBI software to use MTD
interface, because it is _designed_ for UBI, not for MTD.

So, having native interface for ubi-only software looks reasonable. But
we also able to integrate UBI into MTD for MTD software, which looks a
good design decision and a good compromise.

P.S: Also, I'd ask you to look at the monster mtd_info data structure
and be scared :-) Imagine we add more there.
-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

