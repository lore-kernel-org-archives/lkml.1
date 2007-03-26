Return-Path: <linux-kernel-owner+w=401wt.eu-S965131AbXCZK4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965131AbXCZK4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965148AbXCZK4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:56:25 -0400
Received: from smtp.nokia.com ([131.228.20.171]:38786 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965131AbXCZK4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:56:24 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Matt Mackall <mpm@selenic.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070325200826.GA19691@lazybastard.org>
References: <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org>
	 <1174338329.13341.633.camel@localhost.localdomain>
	 <20070319223205.GZ4892@waste.org>
	 <1174351366.13341.739.camel@localhost.localdomain>
	 <20070321110528.GC3785@lazybastard.org>
	 <1174476334.10840.49.camel@localhost.localdomain>
	 <20070325200826.GA19691@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 26 Mar 2007 13:49:06 +0300
Message-Id: <1174906146.1542.18.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Mar 2007 10:49:06.0929 (UTC) FILETIME=[6090BE10:01C76F94]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070326134925-5F74CBB0-6B3512D0/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 22:08 +0200, Jörn Engel wrote:
> And there is no fundamental reason why UBI should export blocks with
> non-power-of-two sizes.

False. There is.

>   UBI currently consists of two parts that are
> intimately intertwined in the current implementation, but have
> relatively little connection otherwise.

False. They do have connection.

> 1. Logical volume management.
> 2. Static volumes.
> 
> Logical volume management can just as easily move its management
> information into a table, instead of having it spread across all blocks.
> Blocks can keep their original size.  Since you have to scan flash
> anyway, you can also scan for a table, compare a magical number and do
> some extra check to protect yourself against a UBI image inside some
> logical volume.  No big deal.

First off, I see these no big deal statements for years already, and no
decent implementation proved by usage in real world. Could we please,
move these academic discussions to another thread?

Second, it is much more robust to kip erase counter and mapping
information on per-eraseblock basis then to keep any on-flash table -
you may always scan whole media and gracefully recover from errors and
corruptions. And you do not loose use a lot in case of corruptions. 

Third, it is much simpler then keeping any on-flash table, it is thus
robust. We do not need a journal to update any table.

Third, if needed, on-flash table may be _added_ to increase scalability,
so "since you have to scan flash anyway" may become false when there is
real need in better scalability. For now scanning is OK. And still,
scanning method will be a good fall-back way to recover from errors.

> UBI is just as broken as LogFS is.  It works with every user in mainline
> (which comes down to JFFS2).  LogFS works with every MTD device in
> mainline.  The only combination that doesn't work is LogFS on UBI - due
> to deliberate design decisions on both sides.

You are welcome to discuss other irrelevant things to this thread.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

