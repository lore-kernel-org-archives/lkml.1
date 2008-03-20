Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbYCTTNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbYCTTNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 15:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbYCTTM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 15:12:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42751 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019AbYCTTM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 15:12:57 -0400
Date: Thu, 20 Mar 2008 20:12:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jon Masters <jcm@jonmasters.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jon Masters <jcm@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] Markers Support for Proprierary Modules
Message-ID: <20080320191205.GA13309@elte.hu>
References: <20080320002737.918213455@polymtl.ca> <20080320002835.384758480@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320002835.384758480@polymtl.ca>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> There seems to be good arguments for markers to support proprierary 
> modules. So I am throwing this one-liner in and let's see how people 
> react. [...]

ugh, this is unbelievably stupid move technically - so a very strong 
NACK. Allowing marker use in unfixable modules (today it's placing 
markers into unfixable modules, tomorrow it's marker use by such 
modules) has only one clear and predictable effect: it turns marker 
calls into essential ABIs because when faced with any breakage in an 
unfixable module that makes use of a marker in some kernel subsystem 
then all the pressure is on those who _can_ fix their code - meaning the 
kernel subsystem maintainers that use markers.

unfixable modules should only be allowed access to easy things they can 
access anyway, or to such fundamental things which we wont realistically 
change anyway. Markers are neither.

(i also find it puzzling why you go out on a limb helping a piece of 
_irrelevant_ technology that has been the unparalleled source of pain 
and anguish to both kernel users and kernel developers.)

	Ingo
