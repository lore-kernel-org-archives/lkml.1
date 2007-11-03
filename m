Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbXKCT0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbXKCT0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbXKCT0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:26:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55749 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755173AbXKCT0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:26:09 -0400
Date: Sat, 3 Nov 2007 12:26:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711031859340.14407@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0711031224130.5695@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031143140.5527@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711031859340.14407@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Hugh Dickins wrote:

> On Sat, 3 Nov 2007, Christoph Lameter wrote:
> > On Sat, 3 Nov 2007, Hugh Dickins wrote:
> > 
> > > Which fixes the leakage: Objects and Partials then remain stable.
> > 
> > Well this code is just an optimization for a rare case.
> > Your patch may not handle the debug situation the right way.
> 
> Oh?  How?

If SLAB_DEBUG is set then your patch does not do the proper checks for the 
object, tracing information is not written and the poisoning is not done. 
See alloc_debug_processing().

