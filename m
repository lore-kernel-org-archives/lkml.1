Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbZAFEf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbZAFEf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 23:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZAFEfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 23:35:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:52732 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZAFEfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 23:35:14 -0500
Date: Mon, 5 Jan 2009 20:37:06 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/6] fastboot: Asynchronous function calls to speed up
 kernel boot
Message-ID: <20090105203706.426cdc1f@infradead.org>
In-Reply-To: <20090105202514.399da36e.akpm@linux-foundation.org>
References: <20090105200959.04a626ac@infradead.org>
	<20090105201041.3289d3dd@infradead.org>
	<20090105202514.399da36e.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 20:25:14 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 5 Jan 2009 20:10:41 -0800 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> >  kernel/async.c         |  307
> > ++++++++++++++++++++++++++++++++++++++++++++++++
> 
> Am still wondering if this is unacceptably duplicative of dhowells's
> slow-work infrastructure: http://lkml.org/lkml/2008/11/20/193
> 
> 

I talked to David about this today (as I wrote in 0/6). 
Based on that discussion we got to the conclusion we have incompatible
requirements. He needs priorities to be honored (which means rather out
of order execution of the tasks) while I need strict ordering (for the
synchronization). While it's not entirely impossible to combine those
two into one system, the resulting complexity isn't really worth it yet.

Of the 307 lines, only 100 are actual thread pool code (the rest is
synchronization and admin code), and about half of those 100 lines are
comments.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
