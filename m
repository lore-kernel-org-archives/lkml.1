Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZHYJOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZHYJOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZHYJOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:14:41 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:52982 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751308AbZHYJOl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:14:41 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz1432R98dN936eMa594izz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KOXDO4-01-46O-02
X-M-MSG: 
Date: Tue, 25 Aug 2009 11:13:53 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] sched: Detect child domain of NUMA (aka NODE)
	domain
Message-ID: <20090825091353.GH20811@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820134347.GB29327@alberich.amd.com> <1251128058.7538.299.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1251128058.7538.299.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Aug 2009 09:13:53.0711 (UTC) FILETIME=[5DFA1BF0:01CA2564]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 05:34:18PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-08-20 at 15:43 +0200, Andreas Herrmann wrote:
> > On multi-node processors a NUMA node might not span a socket.
> > Instead a socket might span several NUMA nodes.
> > 
> > This patch introduces a check whether NODE domain is parent
> > of MC domain and sets s_data.numa_child_level accordingly.
> > (See previous patch for further details.)
> 
> right, except that the previous patch
> was rather cryptic :/

Sorry for that.

> So you're proposing to have the NODE level depend on multi-node and then
> flip NODE and CPU around?

Conditioned.

Only if a NUMA node does not span an entire socket, e.g.
  node 0: 0-3
  node 1: 4-7
  socket 0: 0-3, 4-7

You may have a SRAT that describes one NUMA node containing all
sockets, e.g.
  node 0: 0-7
  socket 0 : 0-7
If we have something like that on a multi-node processor system then
we don't need to flip NODE and CPU around.

Same is true if there is no SRAT or SRAT is bogus or CONFIG_ACPI_NUMA=n.

In theory, I could also think of node interleaving where a NUMA node
spans internal nodes of a socket on a multi-node processor -- no flip
in domain hierarchy needed.



On balance, as soon as a socket spans more than one NUMA node we have
to flip NODE and CPU.


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


