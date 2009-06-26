Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZFZJpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZFZJpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZFZJpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:45:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58274 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZFZJpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:45:25 -0400
Date: Fri, 26 Jun 2009 11:45:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 2/9] x86: introduce a set of platform feature flags
Message-ID: <20090626094514.GB12571@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com> <20090626072218.GH14078@elte.hu> <20090626101446.114edbe2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626101446.114edbe2@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Whether a given platform has a 'standard PC' or some custom 
> > driver then depends on that driver's init sequence - it's not a 
> > central thing.
> 
> How exactly do you propose to handle boot memory allocation (eg 
> EBDA) with a driver ? Perhaps you can explain "driverize" as it 
> isn't in any dictionary and I'm not at all clear what you are on 
> about ?

Which bit is not clear? We've been continuously 'driverizing' the 
jumbled mess of x86 platform support code in the past ~1-2 years. 
Things like x86_quirks or struct apic and other similar code 
restructuring and cleanups. They are (of course) not classic 'driver 
core' drivers (many of the core kernel facilities are not available 
yet at this early stage), but properly abstracted, function vector 
driven approaches are still a must.

This series of patches increases the mess in that area, and that's a 
step backwards. It sprinkles the code with a fair amount of 'if 
(feature_x)' conditions instead of cleanly separating out proper 
abstractions.

	Ingo
