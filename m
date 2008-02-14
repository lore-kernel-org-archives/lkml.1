Return-Path: <linux-kernel-owner+w=401wt.eu-S933627AbYBNVRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627AbYBNVRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbYBNVRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:17:07 -0500
Received: from smtp-out.google.com ([216.239.45.13]:58224 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632AbYBNVRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:17:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=TEBHRFCtyGdlxd1ztxEsoIhua3pvTZXIIBTikvHBJdNk455nfJwSim3I7PJ/bEaaI
	FznoCpgExNTHNsgLrxfnA==
Date: Thu, 14 Feb 2008 13:16:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, mel@csn.ul.ie,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Ray Lee <ray-lk@madrabbit.org>
Subject: Re: [RFC] bitmap relative operator for mempolicy extensions
In-Reply-To: <2c0942db0802141255o5d18c6bfxe052ba9512a18817@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0802141314390.1708@chino.kir.corp.google.com>
References: <20080214123528.25274.84387.sendpatchset@jackhammer.engr.sgi.com>  <2f11576a0802140611h261b9df2qd13406e562f52864@mail.gmail.com>  <20080214103541.10943567.pj@sgi.com> <2c0942db0802141255o5d18c6bfxe052ba9512a18817@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Ray Lee wrote:

> map_bitmap violates your naming convention, bitmap_map isn't all that
> clear, bitmap_remap is taken, and while it is one-to-one and onto, I
> think calling it bitmap_bijection would lose everyone except the
> mathematicians. bitmap_onto? bitmap_map_onto? bitmap_map_bitmap_onto?
> 

Whatever this operation ends up being called should be mirrored in the 
name of the new mempolicy flag being introduced, so this will need to be 
finalized before MPOL_F_RELATIVE_NODES can be proposed.

> Minor suggestion:
> + * and the n-th bit of @relmap is the m-th set bit of @relmap.
> 
> Perhaps s/is the/is also the/, so that the reader doesn't try to
> second guess if you accidentally wrote @relmap twice instead of one of
> them being @orig.
> 

There's also an extra "is" in the description:

--- 2.6.24-mm1.orig/lib/bitmap.c	2008-02-04 10:41:35.656945848 -0800
+++ 2.6.24-mm1/lib/bitmap.c	2008-02-14 03:18:08.190311785 -0800
@@ -698,6 +698,69 @@ int bitmap_bitremap(int oldbit, const un
 }
 EXPORT_SYMBOL(bitmap_bitremap);
 
+/**
+ * bitmap_relative - translate one bitmap relative to another
+ *	@dst: resulting translated bitmap
+ * 	@orig: original untranslated bitmap
+ * 	@relmap: bitmap relative to which translated
+ *	@bits: number of bits in each of these bitmaps
+ *
+ * Set the n-th bit of @dst iff there exists some m such that the
+ * n-th bit of @relmap is set, the m-th bit of @orig is is set,

on the last line of this snippet.

		David
