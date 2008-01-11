Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbYAKL0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbYAKL0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 06:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbYAKL0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 06:26:15 -0500
Received: from mx1.suse.de ([195.135.220.2]:46077 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757459AbYAKL0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 06:26:14 -0500
Date: Fri, 11 Jan 2008 12:26:12 +0100
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080111112612.GW25945@bingen.suse.de>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <20080110095337.GK25945@bingen.suse.de> <20080110100443.GB28209@elte.hu> <20080110100712.GO25945@bingen.suse.de> <20080110105726.GD28209@elte.hu> <20080110111248.GR25945@bingen.suse.de> <20080111071936.GA16175@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111071936.GA16175@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is perfectly possible to construct 
> fully written cachelines, without reading the cacheline first. MOVDQ is 

If you write a aligned full 64 (or 128) byte area and even then you can 
have occassional reads which can be either painfully slow or even incorrect.

> but that's totally besides the point anyway. WC or WB accesses, if a 3D 
> app or a driver does high-freq change_page_attr() calls, it will _lose_ 
> the performance game:

Yes, high frequency as in doing it in fast paths is not a good idea, but 
reasonably low frequency (as in acceptable process exit latencies for 
example) are something to aim for. Right now with WBINVD and other problems 
it is too slow.

> > > in everything from the card and use it. In graphics, if you remap 
> > > anything on the fly and it's not a slowpath you've lost the 
> > > performance game even before you began it.
> > 
> > The typical case would be lots of user space DRI clients supplying 
> > their own buffers on the fly. There's not really a fixed pool in this 
> > case, but it all varies dynamically. In some scenarios that could 
> > happen quite often.
> 
> in what scenarios? Please give me in-tree examples of such high-freq 
> change_page_attr() cases, where the driver authors would like to call it 
> with high frequency but are unable to do it and see performance problems 
> due to the WBINVD.

Some workloads do regular mapping into the GART aperture, but it is
not too critical yet.

But it is not too widely used because it is too slow; but i've got
requests from various parties over the years for more efficient c_p_a().
It's a chicken'n'egg problem -- you're asking for users but the users
don't use it yet because it's too slow.

-Andi
