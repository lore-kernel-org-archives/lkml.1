Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbXH0WPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbXH0WPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbXH0WPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:15:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47497 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751640AbXH0WPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:15:33 -0400
Date: Mon, 27 Aug 2007 15:15:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0708271514020.8891@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca>  <20070820201822.597720007@polymtl.ca>
  <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com> 
 <20070820204126.GA22507@Krystal>  <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
  <20070820212922.GA27011@Krystal>  <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
  <20070820215413.GA28452@Krystal>  <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
  <20070821173849.GA8360@Krystal>  <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com>
 <1188197539.6114.426.camel@twins> <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmmm. One wild idea would be to use a priority futex for the slab lock? 
That would make the slow paths interrupt safe without requiring interrupt 
disable? Does a futex fit into the page struct?

