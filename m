Return-Path: <linux-kernel-owner+w=401wt.eu-S1761611AbZLOXGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761611AbZLOXGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761978AbZLOXGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:06:41 -0500
Received: from khc.piap.pl ([195.187.100.11]:50980 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762621AbZLOXD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:03:56 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: SATA_SIL: Add a work-around for IXP4xx CPU.
References: <m3fx8m0vwh.fsf@intrepid.localdomain>
	<4B274694.6020701@kernel.org>
Date: Wed, 16 Dec 2009 00:03:52 +0100
In-Reply-To: <4B274694.6020701@kernel.org> (Tejun Heo's message of "Tue, 15
	Dec 2009 17:19:32 +0900")
Message-ID: <m3hbrrc013.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hmmm... Given that there are some platforms which have problem with
> mmio and sil3112/4 can do everything via io accesses, it would be nice
> to generalize this so that there's CONFIG_SATA_SIL_NO_MMIO which is
> selected by affected platforms.  Are you interested in doing it?

Unfortunately I no longer have access to that SIL3512 miniPCI card so
I wouln't be able to test on IXP425. Perhaps it's not a problem, testing
on i386 (probably with disabled MMIO BAR) should be enough.

OTOH IIRC SIL3x12 needs to use the MMIO write to start BM DMA, otherwise
the AT-style 64 KB limits apply. I think IXP4xx would benefit from only
ioread8() going through normal IO.

Do you know what platforms have the MMIO problems? What kind of problems
are there, inability to use MMIO at all? (IXP4xx can't do 8/16-bit MMIO
reads).
-- 
Krzysztof Halasa
