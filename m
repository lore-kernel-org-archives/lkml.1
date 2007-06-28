Return-Path: <linux-kernel-owner+w=401wt.eu-S1764133AbXF1IHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764133AbXF1IHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 04:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760139AbXF1IHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 04:07:10 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35389 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759676AbXF1IHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 04:07:08 -0400
X-Sasl-enc: 6vV7VJ2nuoBSD/UoZ/BvDKp1KokewbwB7l9j53ykhMKP 1183018027
Date: Thu, 28 Jun 2007 05:07:00 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC #2] hwrng: Add type categories
Message-ID: <20070628080700.GB13258@khazad-dum.debian.net>
References: <200706262021.51410.mb@bu3sch.de> <200706271505.33970.mb@bu3sch.de> <20070627170331.GB6508@khazad-dum.debian.net> <200706271954.16963.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706271954.16963.mb@bu3sch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Michael Buesch wrote:
> Ok, all very good ideas. Patches are welcome ;)

Not from me, sorry. I really don't have the time, or the drive, to do it
right now.  thinkpad-acpi is taking all my "kernel code" time, which is not
much.

> > I don't much like sysfs over IOCTLs for this, as you will probably need to
> > be able to set and get things in an atomic way.  A sysfs binary attribute
> > would also work.  A sysfs one-value-per-attribute bunch of them is
> > completely useless from a security point of view.
> 
> hm? Why?

Because you cannot risk anyone changing one of them behind your back while
you are trying to set them all before you lock them.  And I am not even
considering an attack scenario, I am considering two apps trying to set it
up concurrently.

You need some sort of locking for this sort of device, and exclusive open +
ioctl solves the problem completely.  Sysfs is not made for this kind of
thing.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
