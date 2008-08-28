Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbYH1U4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbYH1U4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbYH1U4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:56:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59543
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753696AbYH1U4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:56:14 -0400
Date: Thu, 28 Aug 2008 13:56:09 -0700 (PDT)
Message-Id: <20080828.135609.106382483.davem@davemloft.net>
To: Brice.Goglin@inria.fr
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC] export irq_set/get_affinity() for multiqueue network
 drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <48B708E1.4070001@inria.fr>
References: <48B708E1.4070001@inria.fr>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brice Goglin <Brice.Goglin@inria.fr>
Date: Thu, 28 Aug 2008 22:21:53 +0200

> With more and more drivers using multiqueues, I think we need a nice way
> to bind MSI-X from within the drivers. I am not sure what's best, the
> attached (untested) patch would just export the existing
> irq_set_affinity() and add irq_get_affinity(). Comments?

I think we should rather have some kind of generic thing in the
IRQ layer that allows specifying the usage model of the device's
interrupts, so that the IRQ layer can choose a default affinities.

I never notice any of this complete insanity on sparc64 because
we flat spread out all of the interrupts across the machine.

What we don't want it drivers choosing IRQ affinity settings,
they have no idea about NUMA topology, what NUMA node the
PCI controller sits behind, what cpus are there, etc.  and
without that kind of knowledge you cannot possible make
affinity decisions properly.
