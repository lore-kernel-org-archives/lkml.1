Return-Path: <linux-kernel-owner+w=401wt.eu-S2992567AbXCBQMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992567AbXCBQMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992569AbXCBQMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:12:08 -0500
Received: from ns1.coraid.com ([65.14.39.133]:8595 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992567AbXCBQMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:12:07 -0500
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2007 11:12:07 EST
Message-ID: <8d855010270590ff0cad9e99e7b95863@coraid.com>
To: akpm@linux-foundation.org, hch@infradead.org
CC: support@coraid.com, ecashin@coraid.com, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: PATCH 2.6.21-rc1 aoe: handle zero _count pages in bios
From: Sam Hopkins <sah@coraid.com>
Date: Fri, 2 Mar 2007 10:51:00 -0500
In-Reply-To: <20070301210942.ebf40993.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, given that bi_end_io() is called after the "io" has completed, I'm
> assuming that networking has completely finished with the memory by the
> time bi_end_io() gets called.
> 
> I guess one can envisage situations where that might not happen, but they'd
> be terribly buggy ones, surely.

This is actually quite common when using broadcom chipsets that take a
long time to clean out the tx ring.  We send a command skb out to
write some data, get the response some tens of ms later and the
command skb (with the pages) still sits in the tx ring.  I've gone to
some lengths to limit the skb memory used in aoe to help with the
OOM/swap issue and this has given me headaches.

Sam

