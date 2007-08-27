Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbXH0WaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbXH0WaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbXH0WaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:30:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48348 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753016AbXH0W36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:29:58 -0400
Date: Mon, 27 Aug 2007 15:29:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070827222715.GA16982@Krystal>
Message-ID: <Pine.LNX.4.64.0708271528080.9100@schroedinger.engr.sgi.com>
References: <1188197539.6114.426.camel@twins>
 <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com>
 <20070827202203.GB5653@Krystal> <Pine.LNX.4.64.0708271324001.5884@schroedinger.engr.sgi.com>
 <20070827203913.GA7416@Krystal> <Pine.LNX.4.64.0708271401070.6435@schroedinger.engr.sgi.com>
 <20070827211003.GA10627@Krystal> <Pine.LNX.4.64.0708271421130.6566@schroedinger.engr.sgi.com>
 <20070827213845.GB9748@Krystal> <Pine.LNX.4.64.0708271510020.8783@schroedinger.engr.sgi.com>
 <20070827222715.GA16982@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Mathieu Desnoyers wrote:

> Hrm, I just want to certify one thing: A lot of code paths seems to go
> to the slow path without requiring cmpxchg_local to execute at all. So
> is the slow path more likely to be triggered by the (!object),
> (!node_match) tests or by these same tests done in the redo after the
> initial cmpxchg_local ?

The slow path is more likely to be triggered by settings in the per cpu 
structure. The cmpxchg failure is comparatively rare. So the worst case
is getting worse but the average use of interrupt enable/disable may not 
change much. Need to have some measurements to confirm that. I can try to 
run the emulation on IA64 and see what the result will be.

