Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbZKXHTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbZKXHTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZKXHTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:19:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39195 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbZKXHTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:19:35 -0500
Date: Tue, 24 Nov 2009 08:19:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
       Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/8] x86: UV - XPC fixes with related support
 functionality V2.
Message-ID: <20091124071931.GA4575@elte.hu>
References: <20091119173157.337874000@alcatraz.americas.sgi.com>
 <20091123180321.GB15594@elte.hu>
 <20091123181049.GA5220@elte.hu>
 <20091123235751.GX6671@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123235751.GX6671@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> > Regarding the patches - i still very much dislike how the code 
> > interfaces to the 'BIOS'. The drivers/misc/sgi-xp/ code looks rather 
> > messy.
> > 
> > Why isnt a pure hardware interface exposed, as both hpa and me 
> > suggested in the past?
> 
> The information is stored on hardware (UV-Hub and RAM) outside this 
> instance of hardware.
> 
> The only safe way to access that hardware is via the GRU.
> 
> No GRU resources are available to the BIOS.
> 
> Ergo, this interface method with multiple passes is needed.
> 
> If there is a better way, I am open to suggestions.

Erm, the better way is to not use the BIOS but to access those registers 
that the BIOS accesses? (which is currently hidden by the BIOS)

In other words, we want to remove arch/x86/kernel/bios_uv.c and the 
uv_bios_call*() APIs and replace them via clear implementations for 
clear hardware abstractions. That 'bios message queue' thing is absolute 
madness for example. But the type-opaque software API too.

	Ingo
