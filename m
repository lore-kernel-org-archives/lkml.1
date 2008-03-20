Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbYCTWXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbYCTWXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbYCTWXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:23:03 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:49979 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522AbYCTWXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:23:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As4EAByB4kdMQWoK/2dsb2JhbACBWql7
Date: Thu, 20 Mar 2008 18:22:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jon Masters <jcm@jonmasters.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jon Masters <jcm@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] Markers Support for Proprierary Modules
Message-ID: <20080320222258.GA15511@Krystal>
References: <20080320002737.918213455@polymtl.ca> <20080320002835.384758480@polymtl.ca> <20080320191205.GA13309@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080320191205.GA13309@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:08:12 up 20 days, 18:19,  6 users,  load average: 0.57, 0.71,
	0.77
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > There seems to be good arguments for markers to support proprierary 
> > modules. So I am throwing this one-liner in and let's see how people 
> > react. [...]
> 
> ugh, this is unbelievably stupid move technically - so a very strong 
> NACK. Allowing marker use in unfixable modules (today it's placing 
> markers into unfixable modules, tomorrow it's marker use by such 
> modules) has only one clear and predictable effect: it turns marker 
> calls into essential ABIs because when faced with any breakage in an 
> unfixable module that makes use of a marker in some kernel subsystem 
> then all the pressure is on those who _can_ fix their code - meaning the 
> kernel subsystem maintainers that use markers.
> 
> unfixable modules should only be allowed access to easy things they can 
> access anyway, or to such fundamental things which we wont realistically 
> change anyway. Markers are neither.
> 
> (i also find it puzzling why you go out on a limb helping a piece of 
> _irrelevant_ technology that has been the unparalleled source of pain 
> and anguish to both kernel users and kernel developers.)
> 
> 	Ingo

Please note that this patch has a single purpose : to let proprietary
modules define markers to *export* information. The opposite (connect
callbacks to markers) is not allowed since the rest of the markers API
is EXPORT_SYMBOL_GPL'd.

I would also be strongly against letting proprietary modules access the
information provided by the markers. However, I think it's only useful
for the end user to let proprietary modules open up a bit, considering
that proprierary module writers can use the markers as they want
in-house, but would have to leave them disabled on shipped kernels.

As far as I am concerned, I want to help the end user, not the
technology itself.

Unless I have a proof that markers in proprietary modules (information
*providers* only) would be a pain to maintain, I won't object against
supporting proprietary modules.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
