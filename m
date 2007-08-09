Return-Path: <linux-kernel-owner+w=401wt.eu-S935825AbXHIAYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935825AbXHIAYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764386AbXHIAYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:24:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:45065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764317AbXHIAYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:24:23 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
Date: Thu, 9 Aug 2007 02:24:16 +0200
User-Agent: KMail/1.9.6
Cc: Glauber de Oliveira Costa <glommer@gmail.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Steven Rostedt <rostedt@goodmis.org>
References: <11865467522495-git-send-email-gcosta@redhat.com> <5d6222a80708080749t35c5c0ceo8b3b8f0cce50c666@mail.gmail.com> <1186615137.17470.100.camel@localhost.localdomain>
In-Reply-To: <1186615137.17470.100.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708090224.16328.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007 01:18:57 Rusty Russell wrote:
> On Wed, 2007-08-08 at 11:49 -0300, Glauber de Oliveira Costa wrote:
> > On 8/8/07, Andi Kleen <ak@suse.de> wrote:
> > > > +EXPORT_SYMBOL(paravirt_ops);
> > >
> > > Definitely _GPL at least.
> > Sure.
> 
> We ended up making it EXPORT_SYMBOL in i386 because every driver wants
> to save and restore interrupt state.

Ah true.
 
> But questionably-licensed drivers might be less of a concern on x86-64.

Nvidia/ATI and other binary modules exist too and users will probably unhappy 
if they cannot run them anymore.

But at usually irq state changes should be patched in anyways and won't
need paravirt I guess? 

Hmm, actually thinking about it the module loader probably has no clue
that the relocation it linked will be overwritten so it'll check
for the export anyways.

So the alternatives would be to add ugly hacks to the module loader
or split paravirt_ops in "common" and "low level system" areas or 
export it as a normal export.

Not sure what's best. Ok using a normal export is easiest and not
that big an issue.

-Andi
