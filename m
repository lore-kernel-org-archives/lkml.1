Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbXDMQqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbXDMQqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXDMQqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:46:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:40778 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbXDMQqY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:46:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,408,1170662400"; 
   d="scan'208"; a="213046902:sNHT708804537"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [KJ][PATCH 02/03]ROUND_UP|DOWN macro cleanup in arch/ia64,x86_64
Date: Fri, 13 Apr 2007 09:45:49 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A015B4E12@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070413043140.GA9431@arun.site>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [KJ][PATCH 02/03]ROUND_UP|DOWN macro cleanup in arch/ia64,x86_64
Thread-Index: Acd9hF0NZzHmBNV5S7maTkUBfaSzNgAZHGjw
From: "Luck, Tony" <tony.luck@intel.com>
To: "Milind Arun Choudhary" <milindchoudhary@gmail.com>
Cc: <kernel-janitors@lists.osdl.org>, <linux-ia64@vger.kernel.org>,
       <discuss@x86-64.org>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <ak@suse.de>
X-OriginalArrivalTime: 13 Apr 2007 16:45:46.0261 (UTC) FILETIME=[2EFF2C50:01C77DEB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So as ALIGN macro does the same work as ROUNDUP,

Although it is mathematically the same operation, the
semantic associations of the name are important too.
If I have an I/O device that works in blocks of a given
size, I don't think that I'm "aligning" a request to make
it match the capabilities of the device, I think that I'm
"rounding up" to a multiple of the size.

Maybe this is because I started out in mathematics before
discovering that computers were so much fun, or maybe it
is a British-English bias ... I can't tell, but it makes
sense to me to use ROUNDUP in some places, and ALIGN in
others.

I haven't scanned through all usages to see whether existing
usage matches my bias ... but changing them all to use just
one name doesn't feel like the right thing to do.  It makes
some code less clear (to me).

>      is at a common place
>      & is accessible to everyone

If ROUNDUP isn't available everywhere, then it should be. To
avoid code duplication perhaps we should add:

    #define ROUNDUP(size, len) ALIGN((size), (len))

and delete the previous ROUNDUP definition?

-Tony
