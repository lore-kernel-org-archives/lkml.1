Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbXLMNIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbXLMNIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXLMNIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:08:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60536 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbXLMNIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:08:41 -0500
Date: Thu, 13 Dec 2007 14:08:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, markus.t.metzger@gmail.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071213130814.GC28340@elte.hu>
References: <20071210123809.A14251@sedona.ch.intel.com> <20071210202052.GA26002@elte.hu> <029E5BE7F699594398CA44E3DDF5544401130A1E@swsmsx413.ger.corp.intel.com> <20071211145301.GA19427@elte.hu> <029E5BE7F699594398CA44E3DDF554440115D3C5@swsmsx413.ger.corp.intel.com> <20071212110330.GD1611@elte.hu> <029E5BE7F699594398CA44E3DDF554440115D6DC@swsmsx413.ger.corp.intel.com> <20071213102939.GS8977@elte.hu> <029E5BE7F699594398CA44E3DDF5544401186D54@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029E5BE7F699594398CA44E3DDF5544401186D54@swsmsx413.ger.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> The ptrace API would allow the user to:
> - define (and query) the overflow mechanism 
>   (wrap-around or event)
> - define (and query) the size of the buffer within certain limits
>   (we could either give an error or cut off)
> - define (and query) events to be monitored
>   (last branch trace, scheduling timestamps)
> - get a single BTS record
> - query the number of BTS records
>   (to find out how big your drain buffer needs to be; it may be bigger
> than you requested)
> - drain all BTS records (copy, then clear)
> - clear all BTS records
> 
> Draining would require the user to allocate a buffer to hold the data, 
> which might not be feasible when he is near his memory limit. He could 
> fall back to looping over the single-entry get. It is questionable, 
> how useful the drain ptrace command would actually be; we might want 
> to replace it with a get range command.
> 
> Are you OK with this?

this sounds a lot more flexible to me. Please, once it looks good to all 
of us also extend LTP's ptrace bits with unit tests for these API 
additions. (Cc: such LTP bits to subrata@linux.vnet.ibm.com)

	Ingo
