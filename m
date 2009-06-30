Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbZF3WSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbZF3WSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZF3WSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:18:32 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:55106 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752710AbZF3WSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:18:31 -0400
Date: Tue, 30 Jun 2009 18:18:24 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <alpine.DEB.2.00.0906301445070.26290@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0906301816520.11362@gentwo.org>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>  <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net>  <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com>  <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>
 <alpine.DEB.1.10.0906301030260.6124@gentwo.org> <1246374095.8014.28.camel@penberg-laptop> <alpine.DEB.1.10.0906301114450.3879@gentwo.org> <alpine.DEB.2.00.0906301248000.16312@chino.kir.corp.google.com> <alpine.DEB.1.10.0906301632570.22158@gentwo.org>
 <alpine.DEB.2.00.0906301413460.24397@chino.kir.corp.google.com> <alpine.DEB.1.10.0906301722280.17682@gentwo.org> <alpine.DEB.2.00.0906301445070.26290@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, David Rientjes wrote:

> I'm curious whether there would ever be any use for disabling debugging on
> specific caches for reasons other than higher minimum orders for metadata,
> though, given that we already support things like slub_debug=FZ,cache,
> which should only enable free debugging and redzoning even with
> CONFIG_SLUB_DEBUG_ON enabled for cache.

One of the reasons for disabling debugging is to speed up the kernel. Race
conditions may vanish due to the additional latency added by the debugging
code. Ideally you know which slab cache has the race and you only would
enable it on that one.

