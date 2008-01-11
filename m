Return-Path: <linux-kernel-owner+w=401wt.eu-S1762006AbYAKRC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006AbYAKRC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760274AbYAKRCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:02:48 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:57830 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760647AbYAKRCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:02:47 -0500
Date: Fri, 11 Jan 2008 09:02:46 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
In-Reply-To: <20080111071936.GA16175@elte.hu>
Message-ID: <alpine.DEB.0.999999.0801110856230.9361@twinlark.arctic.org>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <20080110095337.GK25945@bingen.suse.de> <20080110100443.GB28209@elte.hu> <20080110100712.GO25945@bingen.suse.de> <20080110105726.GD28209@elte.hu> <20080110111248.GR25945@bingen.suse.de>
 <20080111071936.GA16175@elte.hu>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008, Ingo Molnar wrote:

> * Andi Kleen <ak@suse.de> wrote:
> 
> > Cached requires the cache line to be read first before you can write 
> > it.
> 
> nonsense, and you should know it. It is perfectly possible to construct 
> fully written cachelines, without reading the cacheline first. MOVDQ is 
> SSE1 so on basically in every CPU today - and it is 16 byte aligned and 
> can generate full cacheline writes, _without_ filling in the cacheline 
> first.

did you mean to write MOVNTPS above?


> Bulk ops (string ops, etc.) will do full cacheline writes too, 
> without filling in the cacheline.

on intel with fast strings enabled yes.  mind you intel gives hints in
the documentation these operations don't respect coherence... and i
asked about this when they posted their memory ordering paper but got no
response.

-dean
