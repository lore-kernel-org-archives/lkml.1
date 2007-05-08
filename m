Return-Path: <linux-kernel-owner+w=401wt.eu-S934549AbXEHHgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549AbXEHHgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 03:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934410AbXEHHgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 03:36:51 -0400
Received: from www.osadl.org ([213.239.205.134]:44922 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934155AbXEHHgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 03:36:50 -0400
Subject: Re: [PATCH 0/2] LogFS take two
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>
In-Reply-To: <20070507215913.GA15054@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 08 May 2007 09:39:37 +0200
Message-Id: <1178609977.3042.288.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 23:59 +0200, Jörn Engel wrote:

> LogFS has an on-medium tree, fairly similar to Ext2 in structure, so
> mount times are O(1).  In absolute terms, the OLPC system has mount
> times of ~3.3s for JFFS2 and ~60ms for LogFS.

Impressive number

> Motivation 2:
> 
> Flash is becoming increasingly common in standard PC hardware.  Nearly
> a dozen different manufacturers have announced Solid State Disks
> (SSDs), the OLPC and the Intel Classmate no longer contain hard disks
> and ASUS announced a flash-only Laptop series for regular consumers.

With a hardware controller which allows no direct access to the flash.

> And that doesn't even mention the ubiquitous USB-Sticks, SD-Cards,
> etc.

which again do not allow direct access to the flash

> Flash behaves significantly different to hard disks.  In order to use
> flash, the current standard practice is to add an emulation layer and
> an old-fashioned hard disk filesystem.  As can be expected, this is
> eating up some of the benefits flash can offer over hard disks.
> 
> In principle it is possible to achieve better performance with a flash
> filesystem than with the current emulated approach. 

Err, where does JFFS2 use a block emulation layer ?

> Current state:
> 
> LogFS works and survives my testcases.  It has fairly good chances of
> not eating your data during regular operation.  There are still two
> known bugs that will eat data if the filesystem is uncleanly
> unmounted.  Also still missing is wear leveling.

Are you going to make logfs play with UBI ?

> Handling of read/write/erase errors currently is BUG().  It is on my
> list, no need to remind me. :)
> 
> Overall I consider this to be -mm material.

I don't. It seems fs developers tend to have their own view of how to
get stuff mainline.

The code is far from being useful on real world hardware. The error
handling via BUG() is just making it useless. 

Also please fix the coding style and other issues from the seperate
review.

Some useful comments would make a functional review way easier.

>   It would be good to get
> some review and have the usual allyesconfig crowd build it 

make allyesconfig does not work for you ?

	tglx


