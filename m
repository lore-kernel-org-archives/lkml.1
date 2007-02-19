Return-Path: <linux-kernel-owner+w=401wt.eu-S1750916AbXBSKuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916AbXBSKuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbXBSKuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:50:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50809 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbXBSKuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:50:22 -0500
Date: Mon, 19 Feb 2007 10:50:09 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
Message-ID: <20070219105009.GA15792@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 06:54:24PM +0200, Artem Bityutskiy wrote:
> The structure of the UBI code is very simple. Whole UBI consists of units.
> Each unit has one .c file which implements it and one .h file which defines
> the interface of this unit. So I've split the UBI code so that there is
> a distinct patch for each unit header and implementations. Plus there are
> several patches like JFFS2 support, user-space-visible headers, etc.
> To realize what is the unit responsible for, glance at its header - there
> is a short description.

I think this is the wrong approach.  For one thing the unit terms is
rather foregin in Linux, and second this one header file "unit" is
definitly too much.  Normally you'd have as little as possible and at
most four:

 (1) internal definitions of the driver
 (2) external kernel interface of the driver if nessecary
 (3) user interface of the driver if nessecary
 (4) ondisk structure if nessecary

Also please make sure you submit patches at this driver level.  You really
want one git commit per driver that is totally self-contained.  If nessecary
you'd split this into multiple patches if a single one would be bigger then
the message size limit.
