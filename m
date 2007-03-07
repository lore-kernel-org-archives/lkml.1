Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbXCGPel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbXCGPel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbXCGPel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:34:41 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46929 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751999AbXCGPek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:34:40 -0500
Date: Wed, 7 Mar 2007 07:34:38 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: akpm@osdl.org, Marcelo Tosatti <marcelo@kvack.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpm@selenic.com,
       Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [SLUB 2/3] Large kmalloc pass through. Removal of large general
 slabs
In-Reply-To: <1173258077.6374.120.camel@twins>
Message-ID: <Pine.LNX.4.64.0703070732130.9460@schroedinger.engr.sgi.com>
References: <20070307023502.19658.39217.sendpatchset@schroedinger.engr.sgi.com>
  <20070307023513.19658.81228.sendpatchset@schroedinger.engr.sgi.com>
 <1173258077.6374.120.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Peter Zijlstra wrote:

> >  	return -1;
> >  }
> 
> Perhaps so something with PAGE_SIZE here, as you know there are
> platforms/configs where PAGE_SIZE != 4k :-)

Any allocation > 2k just uses a regular allocation which will waste space.

I have a patch here to make this dependent on page size using a loop. The 
problem is that it does not work with some versions of gcc. On the 
other hand we really need this since one arch can 
actually have an order 22 page size!

