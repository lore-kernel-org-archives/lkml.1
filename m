Return-Path: <linux-kernel-owner+w=401wt.eu-S2992442AbXCWPMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992442AbXCWPMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 11:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992449AbXCWPMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 11:12:39 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43632 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992442AbXCWPMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 11:12:39 -0400
Date: Fri, 23 Mar 2007 08:12:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Stephane Eranian <eranian@hpl.hp.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: Re: kmalloc() with size zero
In-Reply-To: <20070323001824.GA26540@frankl.hpl.hp.com>
Message-ID: <Pine.LNX.4.64.0703230811430.21857@schroedinger.engr.sgi.com>
References: <20070323001824.GA26540@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007, Stephane Eranian wrote:

> I ran into an issue with perfmon where I ended up calling
> kmalloc() with a size of zero. To my surprise, this did
> not return NULL but a valid data address.
> 
> I am wondering if this is a property of kmalloc() or simply
> a bug. It is the case that the __kmalloc() code does not
> check for zero size.

Correct SLAB will give you the smallest possible allocation. I'd say these 
calls should be fixed. SLUB does check for zero and will throw a stack 
dump.

