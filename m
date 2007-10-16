Return-Path: <linux-kernel-owner+w=401wt.eu-S1764094AbXJPBIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764094AbXJPBIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 21:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbXJPBIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 21:08:04 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50905 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143AbXJPBIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 21:08:02 -0400
Subject: Re: [PATCH 10/11] maps3: add /proc/kpagecount and /proc/kpageflags
	interfaces
From: Dave Hansen <haveblue@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <20071016005832.GD19691@waste.org>
References: <11.290135367@selenic.com> <1192488513.6118.98.camel@localhost>
	 <20071015231106.GX19691@waste.org> <1192491297.6118.129.camel@localhost>
	 <20071016003538.GC19691@waste.org> <1192495750.6118.152.camel@localhost>
	 <20071016005832.GD19691@waste.org>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 18:07:59 -0700
Message-Id: <1192496879.6118.157.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 19:58 -0500, Matt Mackall wrote:
> 
> > For the bits that we want to export, we could also add the unoptimized
> > access functions for any that don't already have them:
> > 
> > #define __ClearPageReserved(page)       __clear_bit(PG_reserved, &(page)->flags)
> 
> Confused. Why are we interested in clear? 

We're not.  I just grabbed a random line to show the non-atomic
accessors.  Any actual one we'd need to add would be:

#define __PageBuddy(page)         __test_bit(PG_buddy, &(page)->flags)

It looks like we don't have any of these non-atomic ones for plain
__PageFoo().  So, we'd have to add them for each one that we wanted.
Still not much work, and still satisfies the "grep test". :)

-- Dave

