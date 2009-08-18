Return-Path: <linux-kernel-owner+w=401wt.eu-S1752351AbZHRX4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbZHRX4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZHRX4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:56:20 -0400
Received: from aun.it.uu.se ([130.238.12.36]:57403 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbZHRX4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:56:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19083.16290.445891.283072@pilspetsen.it.uu.se>
Date: Wed, 19 Aug 2009 01:56:18 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: completely hide parts of the partition table from Windows?
In-Reply-To: <20090818223522.GA5872@ub>
References: <19083.7062.710265.941247@pilspetsen.it.uu.se>
	<20090818223522.GA5872@ub>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andries E. Brouwer writes:
 > On Tue, Aug 18, 2009 at 11:22:30PM +0200, Mikael Pettersson wrote:
 > 
 > > So what I'm looking for is some sub-partition table format with the
 > > following two properties:
 > > 1. resides in an msdos partition entry of a type that Windows does
 > >    not inspect (for whatever extended partitions or Apple/BSD/Sun
 > >    stuff that Windows may have been taught to recognize)
 > > 2. the locations and sizes of the sub-partitions are NOT limited by
 > >    the parent msdos partition entry
 > 
 > The reason I added type 85 = LINUX_EXTENDED_PARTITION
 > was precisely your concern: it should be something
 > that DOS/Windows doesnt know about.
 > 
 > > I've looked at the code in fs/partitions/msdos.c, and it seems that
 > > most of the extended/BSD/Sun formats don't give me property #2 above.
 > 
 > The standard description of extended partitions says that the size field
 > of the parent extended partition descriptor is irrelevant, only the
 > starting sector matters.
 > 
 > If you look at the parse_extended() code in msdos.c you'll see
 > that it does not use its parameter first_size.
 > (Except in a certain case that you will not be in.)

Right. I misread the "process the data partitions" part to imply
that the limits were enforced for all four entries, not just the
last two usually-junk entries. Thanks for clarifiying that.

 > Make a table that has a Linux extended partition (type 85)
 > that is short enough not to cause Windows to worry. Have logical
 > partitions inside of any size and location you desire.

I have created extended partitions with non-default type
(though not 85). I'll see if I can convince fdisk or parted to
create one with entries exceeding the parent's limits.

Thanks,

/Mikael
