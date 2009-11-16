Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZKPVnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZKPVnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbZKPVnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:43:07 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:25821 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZKPVnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:43:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J+wbHn3MPKKXfmJ+dDBN69MsMgZXOtBIVf4dyhdw9kWliunXWz8WOoA+9PxdTTXtRu
         oFHzLhUrFMwia78w1hGJtBAEXzTU4Cs2HFgNqYsCdYnNqf8GG2X7JjfwuqVHFIkE3f02
         OGWqS0LHbnwbQCkN5FcVecvjjGB5KLlznAgSU=
Date: Tue, 17 Nov 2009 00:43:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] INIT: Limit the number of per cpu calibration
	bootup messages
Message-ID: <20091116214302.GJ5653@lenovo>
References: <20091116210718.412792000@alcatraz.americas.sgi.com> <20091116210728.267482000@alcatraz.americas.sgi.com> <20091116212427.GC2221@elte.hu> <4B01C3DB.3040802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B01C3DB.3040802@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 01:27:55PM -0800, H. Peter Anvin wrote:
> On 11/16/2009 01:24 PM, Ingo Molnar wrote:
> > 
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >> --- linux.orig/init/calibrate.c
> >> +++ linux/init/calibrate.c
> >> @@ -123,23 +123,26 @@
> >>  {
> >>  	unsigned long ticks, loopbit;
> >>  	int lps_precision = LPS_PREC;
> >> +	bool boot_cpu = (smp_processor_id() == 0);
> > 
> > this code is shared by other architectures too - are you sure 
> > smp_processor_id()==0 is a proper 'I am the boot CPU' assumption 
> > everywhere?
> > 
> 
> It really shouldn't be for x86 either, although right now we play nasty
> renumbering games to accommodate that assumption.  It seems like we
> really should have a boot_cpu_id() or some such.
> 
> 	-hpa
> 

It seems we have one

	arch/x86/kernel/setup.c:125:unsigned int boot_cpu_id __read_mostly;

	-- Cyrill
