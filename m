Return-Path: <linux-kernel-owner+w=401wt.eu-S1767342AbXCIQLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767342AbXCIQLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767347AbXCIQLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:11:30 -0500
Received: from kanga.kvack.org ([66.96.29.28]:53884 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767342AbXCIQL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:11:28 -0500
Date: Fri, 9 Mar 2007 11:11:13 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
Subject: Re: [PATCH 2/7] revoke: add f_light flag for struct file
Message-ID: <20070309161113.GM6209@kvack.org>
References: <Pine.LNX.4.64.0703091014110.32320@sbz-30.cs.Helsinki.FI> <200703091108.58371.dada1@cosmosbay.com> <84144f020703090243j6fd49b5eoa23f4cc12866725a@mail.gmail.com> <200703091213.35691.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703091213.35691.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 12:13:35PM +0100, Eric Dumazet wrote:
> Then just drop the fget_light() 'optimisation' and always take a reference 
> (atomic on f_count) regardless of single-thread or not. Instead of dirtying 
> f_light, just do the straightforward thing and be with it.
> 
> (that is : fget_light() = fget() = no more keeping fput_needed everywhere, and 
> convoluted things in some dark sides of the kernel.

And it makes things rather slower for a lot of single threaded applications 
on modern systems.  Yes, fget_light can be done much more cleanly, but please 
don't go around ripping out optimizations just because.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
