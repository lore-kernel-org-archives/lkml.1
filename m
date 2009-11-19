Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZKSIiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZKSIiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 03:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZKSIiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 03:38:11 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:21347 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZKSIiL convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;7:1>);
	Thu, 19 Nov 2009 03:38:11 -0500
Message-Id: <4B0512060200007800020C42@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 19 Nov 2009 08:38:14 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Nick Piggin" <npiggin@suse.de>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Arjan van de Ven" <arjan@infradead.org>,
       <tglx@linutronix.de>, "Shai Fultheim" <shai@scalemp.com>,
       "Ravikiran Thirumalai" <kiran@scalex86.org>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: eliminate redundant/contradicting cache line
	 size config options
References: <4AFD5710020000780001F8F0@vpn.id2.novell.com>
 <20091116041407.GB5818@wotan.suse.de>
 <4B011677020000780001FD9D@vpn.id2.novell.com>
 <20091116105657.GE5818@wotan.suse.de> <20091119035640.GA18236@elte.hu>
 <20091118205240.11d3d660@infradead.org>
 <20091119081307.GA20534@wotan.suse.de>
In-Reply-To: <20091119081307.GA20534@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Nick Piggin <npiggin@suse.de> 19.11.09 09:13 >>>
>On Wed, Nov 18, 2009 at 08:52:40PM -0800, Arjan van de Ven wrote:
>Basically what I think we should do is consider L1_CACHE_BYTES to be
>*the* correct default value to use for 1) avoiding false sharing (which
>seems to be the most common use), and 2) optimal and repeatable per-object
>packing into cachelines (which is more of a micro-optimization to be
>applied carefully to really critical structures).

But then this really shouldn't be called L1_CACHE_... Though I realize
that the naming seems to already be broken - looking over the cache
line specifiers for CPUID leaf 2, there's really no L1 with 128 byte lines,
just two L2s.

One question however is whether e.g. cache line ping-pong between
L3s is really costing that much on non-NUMA, as opposed to it
happening between L1s.

Jan

