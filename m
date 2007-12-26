Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbXLZV26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbXLZV26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 16:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbXLZV2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 16:28:49 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45619 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751612AbXLZV2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 16:28:48 -0500
Date: Wed, 26 Dec 2007 13:28:45 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH] slub: /proc/slabinfo ABI compatibility
In-Reply-To: <84144f020712241259o27f4015ai1128fbb675d079ef@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0712261323050.16904@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0712221446280.24655@sbz-30.cs.Helsinki.FI> 
 <20071222131601.GB32558@elte.hu> <20071222133727.GA12031@elte.hu> 
 <Pine.LNX.4.64.0712241110240.8802@schroedinger.engr.sgi.com>
 <84144f020712241259o27f4015ai1128fbb675d079ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Dec 2007, Pekka Enberg wrote:

> On Dec 24, 2007 9:12 PM, Christoph Lameter <clameter@sgi.com> wrote:
> > Hmmm... What is the combination of config variables that causes this? I
> > moved the count_partial function in mm in order to make the merge of slab
> > defrag easier.
> 
> I think it's CONFIG_PROC_FS without CONFIG_SYSFS.

The only user of count_partial is in slab_objects() which is in a 
section that is

#if defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)

There should be no use if CONFIG_SYSFS is not set. I think we get a 
warning about a function that is never called when compiling the current 
mm code without SLUB_DEBUG or CONFIG_SYSFS (because the slab defrag use 
has not been merged yet).

In mm count_partial() is always defined. In Linus tree count_partial() 
comes just before slab_objects().

