Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbXDEAbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbXDEAbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932375AbXDEAbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:31:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35724 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932359AbXDEAbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:31:16 -0400
Date: Wed, 4 Apr 2007 17:31:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4 (SLUB)
In-Reply-To: <1175730157.5019.19.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704041730470.22161@schroedinger.engr.sgi.com>
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
 <Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0704041120250.793@schroedinger.engr.sgi.com> 
 <1175727185.5019.8.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704041556530.11769@schroedinger.engr.sgi.com>
 <1175730157.5019.19.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Badari Pulavarty wrote:

> On Wed, 2007-04-04 at 15:59 -0700, Christoph Lameter wrote:
> > On Wed, 4 Apr 2007, Badari Pulavarty wrote:
> > 
> > > Here is the slub_debug=FU output with the above patch.
> > 
> > Hmmm... Looks like the object is actually free. Someone writes beyond the 
> > end of the earlier object. Setting Z should check overwrites but it 
> > switched off merging. So set
> > 
> > slub_debug = FZ
> > 
> > Analoguos to the last patch you would need to take out redzoning from 
> > the flags that stop merging. Then rerun. Maybe we can track it down this 
> > way.
> 
> Hmm.. I did that and machine boots fine, with absolutely no
> debug messages :(

Were the slabs merged? Look at /sys/slab and see if there are any symlinks 
there.

