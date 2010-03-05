Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0CEVFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:05:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:51600 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab0CEVFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:05:39 -0500
Subject: Re: [PATCH 3/5] perf, x86: Disable PEBS on clowertown chips
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <1267816553.4942.6.camel@laptop>
References: <20100305153926.639506880@chello.nl>
	 <20100305154128.890278662@chello.nl>
	 <bd4cb8901003051058k5c3d88bewa787f88f03d2da80@mail.gmail.com>
	 <1267816553.4942.6.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 22:05:34 +0100
Message-ID: <1267823134.4997.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 20:15 +0100, Peter Zijlstra wrote:
> On Fri, 2010-03-05 at 10:58 -0800, Stephane Eranian wrote:
> > >        case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
> > > +               x86_pmu.quirks = intel_clowertown_quirks;
> > 
> > That's too coarse grain!
> > It is more subtle than this. Some of the errata are marked as Plan
> > fix. They seem to be
> > fixed in later models. Your looking at the E5xxx series errata but the
> > E7xxx do not have
> > the same problems. 
> 
> OK, I'll look at those errata again and try to come up with a stepping
> test for this errata. 

The two serious ones, AJ106 and AJ68 are no fix and are listed as such
in all errata I can find, including the 7[23]00 series.

I checked the 65nm Core2Duo, Xeon 5200 and Xeon 7[23]00 spec updates.
Going by that it seems the full model 15 family is broken and I'll leave
the patch as is.



