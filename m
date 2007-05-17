Return-Path: <linux-kernel-owner+w=401wt.eu-S1760167AbXEQSrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167AbXEQSrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbXEQSrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:47:03 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57185 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753931AbXEQSrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:47:00 -0400
Date: Thu, 17 May 2007 11:46:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: "Cestonaro, Thilo (external)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>,
       linux-kernel@vger.kernel.org
Subject: Re: How to guarantee that kmalloc returns an address below 4GB
In-Reply-To: <464B02FF.1060000@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0705171145330.3010@schroedinger.engr.sgi.com>
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF054F922A@ABGEX01E.abg.fsc.net>
 <464B02FF.1060000@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Stefan Richter wrote:

> Cestonaro, Thilo (external) wrote:
> > is there an option for kmalloc, which I can use to allocate
> > a buffer which is in physical memory placed below 4GB?
> > Not in a remapped area.
> 
> GFP_DMA32

Nope. There are no general slabs available for DMA32.

You could use a dma slab by specifying GFP_DMA. However, on i386 and 
x86_64 this will get you memory in the precious first 16MB. On IA64 and 
other platforms you will get memory < 4GB.

Another option is to use the page allocator and specify GFP_DMA32.

