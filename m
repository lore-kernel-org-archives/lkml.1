Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYAZD2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYAZD2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 22:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYAZD20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 22:28:26 -0500
Received: from ozlabs.org ([203.10.76.45]:43366 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbYAZD2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 22:28:25 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH] Linux Kernel Markers Support for Proprierary Modules
Date: Sat, 26 Jan 2008 14:27:34 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1201029235.18144.62.camel@perihelion> <Pine.LNX.4.64.0801250840340.12676@fbirervta.pbzchgretzou.qr> <1201275090.25284.281.camel@perihelion>
In-Reply-To: <1201275090.25284.281.camel@perihelion>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801261427.34902.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 January 2008 02:31:30 Jon Masters wrote:
> On Fri, 2008-01-25 at 08:56 +0100, Jan Engelhardt wrote:
> > So what is needed is an Oops with an explaining message
> > if (kernel_tainted) "blame that proprietary module first",
> > and make sure the user sees that oops even if in X.
>
> The former is actually trivially doable with the module->taints bits. We
> could have the equivalent of a neon flashing "blame this module" sign.
>
> I also agree, we should stop force loading. Incompatible struct module,
> etc. are really bad things to have mapped into a running kernel.

I think there are two things here:
1) Currently we allow modules with no kallsyms info to be loaded into a 
KALLSYMS kernel (and taint).  A new option is needed to control this: 
CONFIG_ACCEPT_NO_KALLSYMS under KERNEL_DEBUG which allows loading of 
such "stripped" modules (a-la modprobe --force).

2) Unconditionally reject modules with a wrong module section size.  Currently 
we have no such check, which means without KALLSYMS, anything goes.

Thoughts?
Rusty.
