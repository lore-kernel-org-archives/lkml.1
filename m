Return-Path: <linux-kernel-owner+w=401wt.eu-S1761045AbYAYICY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045AbYAYICY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763488AbYAYH4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:56:14 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:48587 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763469AbYAYH4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:56:11 -0500
Date: Fri, 25 Jan 2008 08:56:09 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH] Linux Kernel Markers Support for Proprierary Modules
In-Reply-To: <20080124124703.GB32559@Krystal>
Message-ID: <Pine.LNX.4.64.0801250840340.12676@fbirervta.pbzchgretzou.qr>
References: <1201029235.18144.62.camel@perihelion> <y0modbdnt4e.fsf@ton.toronto.redhat.com>
 <20080123031005.GA16766@Krystal> <1201061860.25284.28.camel@perihelion>
 <20080123131442.GA6562@redhat.com> <20080123144811.GA12296@Krystal>
 <27267.1201152358@turing-police.cc.vt.edu> <1201155569.25284.88.camel@perihelion>
 <20080124124703.GB32559@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24 2008 07:47, Mathieu Desnoyers wrote:
>On Tue, 2008-01-22 at 22:10 -0500, Mathieu Desnoyers wrote:
>On my part, its mostly a matter of not crashing the kernel when someone
>tries to force modprobe of a proprietary module (where the checksums
>doesn't match) on a kernel that supports the markers. Not doing so
>causes the markers to try to find the marker-specific information in
>struct module which doesn't exist and OOPSes.

>* Frank Ch. Eigler (fche@redhat.com) wrote:
>[...]
>Another way of looking at this though is that by allowing/encouraging
>proprietary module writers to include markers, we and their users get
>new diagnostic capabilities.  It constitutes a little bit of opening
>up, which IMO we should reward rather than punish.


Tackling this from a different angle:

I do not think there is a real reason to forceload a module, even
those with proprietary origin (vmware) or that are of
partially-closed nature (nvidia). vmware source is fully available,
so can be compiled with proper modinfo/vermagic/markers; nvidia uses
a build system trick to include an .o blob, but eventually its .ko
also ends up with a correct modinfo/vermagic.

Forceload is for people which like to trade an unstable system for
not having to install gcc and kernel-source.


>Remember - when a user tries a Linux box with a proprietary module, and the
>experience sucks because the module sucks, they will walk away thinking
>"Linux sucks", not "That module sucks".

So what is needed is an Oops with an explaining message
if (kernel_tainted) "blame that proprietary module first",
and make sure the user sees that oops even if in X.
