Return-Path: <linux-kernel-owner+w=401wt.eu-S1751788AbXBERde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbXBERde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbXBERde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:33:34 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:57277 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751788AbXBERdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:33:33 -0500
Date: Mon, 5 Feb 2007 09:33:20 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
In-Reply-To: <1170664774.3073.1236.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0702050931430.26272@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com> 
 <20070203005316.eb0b4042.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com> 
 <1170525860.3073.1054.camel@laptopd505.fenrus.org> 
 <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com> 
 <20070203172242.e5bf2534.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0702031744060.31986@schroedinger.engr.sgi.com> 
 <1170576977.3073.1100.camel@laptopd505.fenrus.org> 
 <Pine.LNX.4.64.0702042351040.23790@schroedinger.engr.sgi.com>
 <1170664774.3073.1236.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Arjan van de Ven wrote:

> > I still need a solution for the problem of not having enough page flag 
> > bits on i386 NUMA.
> 
> I still don't get why you *really* need such a bit. 

Because otherwise you cannot establish why a page was removed from the 
LRU. If a page is off the LRU for other reasons then one should not 
return the page to the LRU in zap_pte_range. How can this determination 
be made without a page flag?

