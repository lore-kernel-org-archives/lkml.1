Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbYAJKH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbYAJKH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYAJKHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:07:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbYAJKHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:07:15 -0500
Date: Thu, 10 Jan 2008 11:07:12 +0100
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080110100712.GO25945@bingen.suse.de>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <20080110095337.GK25945@bingen.suse.de> <20080110100443.GB28209@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110100443.GB28209@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 11:04:43AM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > >   WBINVD isnt particular fast (takes a few msecs), but why is that a 
> > >   problem? Drivers dont do high-frequency ioremap-ing. It's 
> > >   typically only done at driver/device startup and that's it.
> > 
> > Actually graphics drivers can do higher frequency allocation of WC 
> > memory (with PAT) support.
> 
> but that's not too smart: why dont they use WB plus cflush instead? 

Because they need to access it WC for performance.

> ioremap() will always be slow and we dont care about stupid uses of it.

Uninterruptible msec latencies are too slow even for slow path
initialization code imho.

-Andi
