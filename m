Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbYHRT57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbYHRT57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYHRT5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:57:47 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56345 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbYHRT5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:57:46 -0400
Date: Mon, 18 Aug 2008 20:57:43 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Adam Litke <agl@us.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       nacc <nacc@linux.vnet.ibm.com>, apw <apw@shadowen.org>,
       agl <agl@linux.vnet.ibm.com>
Subject: Re: [BUG] __GFP_THISNODE is not always honored
Message-ID: <20080818195743.GB22601@csn.ul.ie>
References: <1218837685.12953.11.camel@localhost.localdomain> <20080818105918.GD32113@csn.ul.ie> <1219083412.29323.36.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1219083412.29323.36.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/08/08 13:16), Adam Litke didst pronounce:
> <MUCH SNIPPAGE>
> mminit::memmap_init Initialising map node 0 zone 0 pfns 32768 -> 278528
> mminit::memmap_init Initialising map node 1 zone 0 pfns 0 -> 524288

This might be the problem here. This machine has overlapping nodes which
is a fairly rare situation. I think it's possible the page linkages for
node 0 are getting overwritten with their node 1 equivalents. If this is
happening, it would lead to some oddness.

