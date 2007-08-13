Return-Path: <linux-kernel-owner+w=401wt.eu-S938629AbXHMAhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938629AbXHMAhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 20:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759919AbXHMAho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 20:37:44 -0400
Received: from smtprelay07.ispgateway.de ([80.67.29.7]:47488 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbXHMAho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 20:37:44 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Aug 2007 20:37:43 EDT
From: Ingo Oeser <ioe-lkml@rameria.de>
To: "Michael Bourgeous" <sts.nitrogen@gmail.com>
Subject: Re: Driver-level memory management
Date: Mon, 13 Aug 2007 02:37:50 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <8e4fc8270708112014h5f4e9bf1ua9565eab60f915c1@mail.gmail.com>
In-Reply-To: <8e4fc8270708112014h5f4e9bf1ua9565eab60f915c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130237.51501.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Sunday 12 August 2007, Michael Bourgeous wrote:
> I'm working on a driver for older HDTV cards based on the TL880 chip.
> These cards typically have 16MB of their own memory, which is
> available to me over the PCI bus.  Various functions of the card
> require me to manage this memory, allocating and freeing chunks of it
> as necessary.  I can easily include my own allocation and management
> code, 

Ok.

> but I'm sure this is a problem that has been solved before. 

Yes!

in your Kconfig

select GENERIC_ALLOCATOR

in your driver.c

#include <linux/genalloc.h>

Code is in lib/genalloc.c, if you like to take a look.

Memory for MANAGING free/allocated space is NOT taken 
from your on-card memory! That allocator is explicitly developed
for such use cases.

Happy hacking!


Best regards

Ingo Oeser
