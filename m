Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbXJHVMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbXJHVMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbXJHVMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:12:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58347
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbXJHVML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:12:11 -0400
Date: Mon, 08 Oct 2007 14:11:54 -0700 (PDT)
Message-Id: <20071008.141154.107706003.davem@davemloft.net>
To: jeff@garzik.org
Cc: hadi@cyberus.ca, peter.p.waskiewicz.jr@intel.com, krkumar2@in.ibm.com,
       johnpol@2ka.mipt.ru, herbert@gondor.apana.org.au, kaber@trash.net,
       shemminger@linux-foundation.org, jagana@us.ibm.com,
       Robert.Olsson@data.slu.se, rick.jones2@hp.com, xma@us.ibm.com,
       gaagaan@gmail.com, netdev@vger.kernel.org, rdreier@cisco.com,
       mingo@elte.hu, mchan@broadcom.com, general@lists.openfabrics.org,
       kumarkr@linux.ibm.com, tgraf@suug.ch, randy.dunlap@oracle.com,
       sri@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: parallel networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <470A3D24.3050803@garzik.org>
References: <20071007.215124.85709188.davem@davemloft.net>
	<1191850490.4352.41.camel@localhost>
	<470A3D24.3050803@garzik.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Mon, 08 Oct 2007 10:22:28 -0400

> In terms of overall parallelization, both for TX as well as RX, my gut 
> feeling is that we want to move towards an MSI-X, multi-core friendly 
> model where packets are LIKELY to be sent and received by the same set 
> of [cpus | cores | packages | nodes] that the [userland] processes 
> dealing with the data.

The problem is that the packet schedulers want global guarantees
on packet ordering, not flow centric ones.

That is the issue Jamal is concerned about.

The more I think about it, the more inevitable it seems that we really
might need multiple qdiscs, one for each TX queue, to pull this full
parallelization off.

But the semantics of that don't smell so nice either.  If the user
attaches a new qdisc to "ethN", does it go to all the TX queues, or
what?

All of the traffic shaping technology deals with the device as a unary
object.  It doesn't fit to multi-queue at all.
