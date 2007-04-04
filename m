Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbXDDSEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbXDDSEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbXDDSEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:04:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47579 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753628AbXDDSEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:04:46 -0400
Date: Wed, 4 Apr 2007 11:04:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4 (SLUB)
In-Reply-To: <1175709755.6185.34.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> 
 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com> 
 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com> 
 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com> 
 <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031653060.12109@schroedinger.engr.sgi.com> 
 <1175698437.6185.21.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704040946370.24640@schroedinger.engr.sgi.com>
 <1175709755.6185.34.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Badari Pulavarty wrote:

> Machine booted fine with slub_debug=F. Got following in the
> log. I guess we need to track down who is touching after
> free. Any ideas on how I can track down easily ? Is there
> a way to store last allocated (function, line#) and look
> around there ?

Yes. slub_debug=U. But user tracking may need to increase the slab 
size (depends on the padding available in the slab) to store the 
tracking information, so you may not get the same corruption.

> *** SLUB: Freepointer corrupt in kmalloc-16@0xffff810173f172a0 Slab
> 0xffff81017f9f8b80
>     offset=672 flags=0x2000000000000c7 inuse=42
> freelist=0xffff810173f172a0
>   Bytes b4 0xffff810173f17290:  a0 72 f1 73 00 00 00 00 00 00 00 00 00
> 00 00 00 .r\uffffs............
>     Object 0xffff810173f172a0:  00 00 00 00 01 81 ff ff 00 00 00 00 00
> 00 00 00 ......\uffff\uffff........
> FreePointer 0xffff810173f172a0 -> 0xffff810100000000

Same as before.
