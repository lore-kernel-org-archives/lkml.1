Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbZADSMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbZADSMW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZADSMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:12:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:44217 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbZADSMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:12:08 -0500
Date: Sun, 4 Jan 2009 10:13:53 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       fweisbec@gmail.com, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/4] fastboot: make scsi probes asynchronous
Message-ID: <20090104101353.05e8df09@infradead.org>
In-Reply-To: <20090104180515.GD2002@parisc-linux.org>
References: <20090104092430.7ffd2c41@infradead.org>
	<20090104092940.11943797@infradead.org>
	<20090104180515.GD2002@parisc-linux.org>
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

On Sun, 4 Jan 2009 11:05:15 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Sun, Jan 04, 2009 at 09:29:40AM -0800, Arjan van de Ven wrote:
> > >From 2087b546abddced50fa73ea9a71b5a040ae1026e Mon Sep 17 00:00:00
> > >2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Sun, 4 Jan 2009 05:32:28 -0800
> > Subject: [PATCH] fastboot: make scsi probes asynchronous
> > 
> > This patch makes part of the scsi probe (which is mostly device
> > spin up and the partition scan) asynchronous. Only the part that
> > runs after getting the device number allocated is asynchronous,
> > ensuring that device numbering remains stable.
> 
> Is this really a big win?  Were you using the async scsi scan code
> already? 

just checked;
my box has CONFIG_SCSI_SCAN_ASYNC=y set for both cases
it seems to be about 0.1 seconds win still though...
sounds little, but a kernel boot should be less than a second, so that
is still 10%. And it's obviously also disk dependent..
(I used libata connected disks obviously)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
