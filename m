Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbZF3Vwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbZF3Vwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbZF3Vwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:52:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6996 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960AbZF3Vwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:52:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Jh+gqmlOcukYo+yYnc4Kpc8aC28CDeY3CpY75CPwAbZU08EA81kFnvUP30WDcUrVj
	ysPzPSjpRnQuLelLIKRGA==
Date: Tue, 30 Jun 2009 14:52:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <alpine.DEB.1.10.0906301722280.17682@gentwo.org>
Message-ID: <alpine.DEB.2.00.0906301445070.26290@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>  <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net>  <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com>  <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>
 <alpine.DEB.1.10.0906301030260.6124@gentwo.org> <1246374095.8014.28.camel@penberg-laptop> <alpine.DEB.1.10.0906301114450.3879@gentwo.org> <alpine.DEB.2.00.0906301248000.16312@chino.kir.corp.google.com> <alpine.DEB.1.10.0906301632570.22158@gentwo.org>
 <alpine.DEB.2.00.0906301413460.24397@chino.kir.corp.google.com> <alpine.DEB.1.10.0906301722280.17682@gentwo.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Christoph Lameter wrote:

> We could add an option that disables debugging for troublesome page
> size slabs
> 
> 
> slab_debug=p
> 
> or so
> 

I definitely like that more than slab_debug=A, where we're requiring an 
added parameter for full debugging to be activated.

I'm curious whether there would ever be any use for disabling debugging on 
specific caches for reasons other than higher minimum orders for metadata, 
though, given that we already support things like slub_debug=FZ,cache, 
which should only enable free debugging and redzoning even with 
CONFIG_SLUB_DEBUG_ON enabled for cache.

I think the solution to this is really based on good software engineering 
and test practices, though, so hopefully there'll be a consensus on which 
direction to take before any time is spent in implementing and pushing it.
