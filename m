Return-Path: <linux-kernel-owner+w=401wt.eu-S1751326AbZHRXC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbZHRXC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbZHRXC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:02:26 -0400
Received: from hera.cwi.nl ([192.16.191.8]:64597 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbZHRXCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:02:25 -0400
X-Greylist: delayed 1827 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Aug 2009 19:02:25 EDT
Date: Wed, 19 Aug 2009 00:35:23 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, Andries Brouwer <Andries.Brouwer@cwi.nl>
Subject: Re: completely hide parts of the partition table from Windows?
Message-ID: <20090818223522.GA5872@ub>
References: <19083.7062.710265.941247@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19083.7062.710265.941247@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 11:22:30PM +0200, Mikael Pettersson wrote:

> So what I'm looking for is some sub-partition table format with the
> following two properties:
> 1. resides in an msdos partition entry of a type that Windows does
>    not inspect (for whatever extended partitions or Apple/BSD/Sun
>    stuff that Windows may have been taught to recognize)
> 2. the locations and sizes of the sub-partitions are NOT limited by
>    the parent msdos partition entry

The reason I added type 85 = LINUX_EXTENDED_PARTITION
was precisely your concern: it should be something
that DOS/Windows doesnt know about.

> I've looked at the code in fs/partitions/msdos.c, and it seems that
> most of the extended/BSD/Sun formats don't give me property #2 above.

The standard description of extended partitions says that the size field
of the parent extended partition descriptor is irrelevant, only the
starting sector matters.

If you look at the parse_extended() code in msdos.c you'll see
that it does not use its parameter first_size.
(Except in a certain case that you will not be in.)

Make a table that has a Linux extended partition (type 85)
that is short enough not to cause Windows to worry. Have logical
partitions inside of any size and location you desire.

Andries

