Return-Path: <linux-kernel-owner+w=401wt.eu-S932917AbXA1WMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbXA1WMt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932919AbXA1WMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:12:49 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36093 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917AbXA1WMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:12:48 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <greg@kroah.com>, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
       linuxppc-dev@ozlabs.org, Brice Goglin <brice@myri.com>,
       shaohua.li@intel.com, linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/6] MSI portability cleanups
References: <1169714047.65693.647693675533.qpush@cradle>
	<m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
	<1170015805.26655.15.camel@localhost.localdomain>
	<45BD0BDC.40205@garzik.org>
Date: Sun, 28 Jan 2007 15:11:34 -0700
In-Reply-To: <45BD0BDC.40205@garzik.org> (Jeff Garzik's message of "Sun, 28
	Jan 2007 15:47:24 -0500")
Message-ID: <m1y7nmol7t.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> I think the high-level ops approach makes more sense.  It's more future proof,
> in addition to covering all existing implementations.

To be precise in Michaels implementation one of the parameters passed is
a type parameter so that the architecture has to know about each different
type of msi implementation.   In my implementation that field does not exist,
because it is unnecessary.  So as long as the message on the bus is a msi
message my implementation can be adapted to support it without any architecture
changes.

Being future proof is about getting the abstraction correct, and exposing
those details that matter, and removing those detail that don't.

It is a minor nit, not a fundamental flaw in the operations concept.  But
one of the reasons I am opposed to throwing out the current working code.
Evolutionary change ensures that things only the code remembers don't get
left behind.

I guess that is the other part of the discussion that shows up here
is, as long as the change is an evolutionary change from what is
working today.  I don't have any fundamental problems with it, but I
am completely against a revolutionary change.

Meanwhile because Michael has proposed operations my position has been
perceived as against operations.  While I have a lot of technical nits
to pick with the Michaels operations approach, I'm not fundamentally
against it.  I just don't want to loose the information that only
the code remembers.

Most of my technical objections have been formed by looking at what
the code does today, looking at what Michaels code is doing and seeing
details he missed.  If we just start with the current code base and
fix it the whole approach is much easier.

Anyway last I heard Michael was working on starting with the current
msi.c and making his patch set work, and I am hoping that my work
will make that patchset cleaner, and easier to do.  Even if we do
conflict at the moment :)

Eric
