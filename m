Return-Path: <linux-kernel-owner+w=401wt.eu-S973397AbXHMQtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973397AbXHMQtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S972542AbXHMQIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:08:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:6502 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S972526AbXHMQIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:08:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,255,1183359600"; 
   d="scan'208";a="280331935"
Date: Mon, 13 Aug 2007 09:05:33 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, akpm@linux-foundation.org
Subject: Re: [2.6 patch] cpqphp_ctrl.c: remove dead code
Message-Id: <20070813090533.4a363c5a.kristen.c.accardi@intel.com>
In-Reply-To: <20070809233910.GB18938@stusta.de>
References: <20070723145105.GK26212@stusta.de>
	<20070809145140.654303a0.kristen.c.accardi@intel.com>
	<20070809222427.GA32127@suse.de>
	<20070809154702.caa67a61.kristen.c.accardi@intel.com>
	<20070809230436.GA18938@stusta.de>
	<20070809162001.a5dc0b76.kristen.c.accardi@intel.com>
	<20070809233910.GB18938@stusta.de>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 01:39:10 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> As I've wrote in the patch description, all it does is to remove an if() 
> check that could never be false (which is easily verifyable if you look 
> at the source code).
> 
> I've also verified that my patch does not change a single bit in the 
> object file (after compilation with gcc 4.2.1).

while you are correct that your patch will not change the object,
the reason I think that we should not do this patch is because it appears
to me that this code path was meant to be taken, and perhaps it was a 
mistake to return -ENOMEM further up (the reason the code isn't taken).
It seems to me that the thing to do is to leave the code as is, and then when
someone picks up the code again, they can clean it up after they've determined
they truly don't want that code path taken.

My definition of trivial is a patch that is both simple and obviously the 
right thing to do.
Kristen
 
