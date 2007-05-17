Return-Path: <linux-kernel-owner+w=401wt.eu-S1761192AbXEQGZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761192AbXEQGZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXEQGZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:25:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57506 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbXEQGZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:25:33 -0400
Subject: Re: [PATCH] LogFS take three
From: David Woodhouse <dwmw2@infradead.org>
To: Dongjun Shin <djshin90@gmail.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
In-Reply-To: <7fe698080705162312t4e7ed90byd10ef8e664027b17@mail.gmail.com>
References: <20070515151919.GA32510@lazybastard.org>
	 <20070515133759.9ee434a2.akpm@linux-foundation.org>
	 <1179317240.2859.222.camel@shinybook.infradead.org>
	 <20070516083408.dcd9dd78.akpm@linux-foundation.org>
	 <1179330596.2859.248.camel@shinybook.infradead.org>
	 <20070516164158.GB8113@lazybastard.org>
	 <7fe698080705162312t4e7ed90byd10ef8e664027b17@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 17 May 2007 14:25:17 +0800
Message-Id: <1179383117.2859.416.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 15:12 +0900, Dongjun Shin wrote:
> The current trend of flash-based device is to hide the flash-specific details
> from the host OS. The flash memory is encapsulated in a package
> which contains a dedicated controller where a small piece of software (F/W or FTL)
> runs and makes the storage shown as a block device to the host.

Yes. These things are almost always implemented _very_ badly by the same
kind of crack-smoking hobo they drag in off the streets to write BIOSen.

It's bog-roll technology; if you fancy a laugh try doing some real
reliability tests on them time some. Powerfail testing is a good one.
 
This kind of thing is OK for disposable storage such as in digital
cameras, where it doesn't matter that it's no more reliable than a
floppy disc, but for real long-term storage it's really a bad idea.

> IMHO, for a flash-optimized filesystem to be useful and widely-used, it would be better
> to run on a block device and to be designed to run efficiently on top of the FTL.
> (ex. log-structured filesystem on general block device)

There's little point in optimising a file system _specifically_ for
devices which in often aren't reliable enough to keep your data anyway.
You might as well use ramfs.

It's unfortunate really -- there's no _fundamental_ reason why FTL has
to be done so badly; it's just that it almost always is. Direct access
to the flash from Linux is _always_ going to be better in practice --
and that way you avoid the problems with dual journalling, along with
the problems with the underlying FTL continuing to keep (and copy around
during GC) sectors which the top-level filesystem has actually
deallocated, etc.

-- 
dwmw2

