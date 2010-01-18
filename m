Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371Ab0ARO5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0ARO5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759Ab0ARO5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:57:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0ARO5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:57:04 -0500
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <20100118144556.GE10364@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop>
	 <20100118142004.GD10364@nowhere> <1263825158.4283.590.camel@laptop>
	 <20100118144556.GE10364@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 15:56:41 +0100
Message-ID: <1263826601.4283.603.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 15:45 +0100, Frederic Weisbecker wrote:
> 
> > > That requires to know in advance if we have hardware pmu
> > > in the list though (can be a flag in the group).
> > 
> > Good point, but your proposed hw_check_constraint() call needs to know
> > the exact same.
> 
> 
> True. Whatever model we use anyway, both implement the same idea.

Hmm, we seem to already have that problem (which would indicate another
bug in the hw-breakpoint stuff), how do you deal with
hw_perf_{enable,disable}() for the breakpoints?

We could fix this by making these pmu state functions into a callback
list visiting all registered PMUs.

