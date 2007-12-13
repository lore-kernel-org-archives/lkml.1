Return-Path: <linux-kernel-owner+w=401wt.eu-S932775AbXLMUx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbXLMUx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759658AbXLMUxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:53:17 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45678 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759528AbXLMUxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:53:16 -0500
Date: Thu, 13 Dec 2007 12:53:11 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Asit Mallick <asit.k.mallick@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: What was the problem with quicklists and x86-64?
In-Reply-To: <1197578876.15741.163.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0712131251300.18314@schroedinger.engr.sgi.com>
References: <47603321.4030700@goop.org>  <Pine.LNX.4.64.0712131131540.13396@schroedinger.engr.sgi.com>
 <1197578876.15741.163.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Benjamin Herrenschmidt wrote:

> > These issues only exist with NUMA because of the freeing of off node pages 
> > before the TLB flush was done. There was a discussion about this issue and 
> > my fix of simply not freeing the offnode pages early was ignored. Instead 
> > the x86_64 implementation (which has no problems that I know of) was 
> > pulled leaving the issue open in the core. Benjamin Herrrenschmidt 
> > wanted to take a look at these issues (CCing him).
> 
> I don't know how NUMA gets in the picture there, it's probably very x86
> specific thing. The issue we have here happens on other platforms
> unrelated to NUMA. The fact that is tired to NUMA on x86 might be due to
> the way the HW tablewalk operates on these. 

This is a generic NUMA issue here! Quicklist pages that are not on 
the current node are freed without waiting for the TLB flush. The patch 
that I posted fixes that by requiring that all pages be flushed. 
