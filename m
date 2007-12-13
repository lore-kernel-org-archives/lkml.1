Return-Path: <linux-kernel-owner+w=401wt.eu-S933679AbXLMWH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbXLMWH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762858AbXLMWHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:07:17 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49067 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762600AbXLMWHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:07:15 -0500
Date: Thu, 13 Dec 2007 14:07:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
 [2.6.24-rc4-git5: Reported regressions from 2.6.23]
In-Reply-To: <20071209085030.GA14264@elte.hu>
Message-ID: <Pine.LNX.4.64.0712131405390.25120@schroedinger.engr.sgi.com>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu>
 <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
 <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
 <20071208100950.a3547868.akpm@linux-foundation.org>
 <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org>
 <20071208195211.GA3727@elte.hu> <20071208202930.GA17934@elte.hu>
 <84144f020712090020o5bdeb54fqaa9e6578bd066f29@mail.gmail.com>
 <20071209085030.GA14264@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007, Ingo Molnar wrote:

> unless i'm missing something obvious (and i easily might), i see SLUB as 
> SLAB reimplemented with a different queueing model. Not "without 
> queueing".

The "queue" that you are talking about is the freelist of a slab. It exist 
for each slab. SLAB uses a table of free entries there. The freelist is 
limited to a slab and thus the locality of the freelist is bound to 
the same page which avoids NUMA locality checks.


