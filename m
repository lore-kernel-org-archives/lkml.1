Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbXIESZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbXIESZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 14:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbXIESZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 14:25:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45983 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbXIESZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 14:25:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46DEF44E.8070003@s5r6.in-berlin.de>
Date: Wed, 05 Sep 2007 20:24:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Tim Teulings <rael@edge.ping.de>, michal.k.k.piotrowski@gmail.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       debian-powerpc@lists.debian.org, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org,
       =?ISO-8859-1?Q?Kristian_H=F8gsber?= =?ISO-8859-1?Q?g?= 
	<krh@redhat.com>
Subject: Re: [PATCH] Re: Sleep problems with kernels >= 2.6.21 on powerpc
References: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com> <6bffcb0e0708261621q25316becqce7b3ae2176f45a8@mail.gmail.com> <20070827065246.GA21220@ime.usp.br> <46D279E8.10001@edge.ping.de> <46D72BC6.3020809@edge.ping.de> <20070905100754.57ab4e3e.akpm@linux-foundation.org> <46DEEBBE.4070201@s5r6.in-berlin.de> <tkrat.7174534bdd0ddaff@s5r6.in-berlin.de>
In-Reply-To: <tkrat.7174534bdd0ddaff@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rogério Brito wrote on 2007-08-27:
> If things progress well, I will incrementally include features on the
> kernel that I need (I left out, for instance, the Firewire subsystem, so
> that compilation wouldn't take more than an hour here, despite the fact
> that I do need Firewire support on the kernel) and see the point where
> things are not normal.

The trivial pci_set_power_state issue aside, resume is currently
defective with the new firewire-ohci driver:
  - The version in Linus' tree doesn't restore a certain detail of
    IEEE 1394 state during resume, hence some protocols like SBP-2 don't
    work after resume unless you unload and reload the drivers.
  - The version in -mm restores everything but panics soon after resume
    on an APM notebook in combination with some SBP-2 targets.  I have
    yet to try netconsole or so to gather more information.
-- 
Stefan Richter
-=====-=-=== =--= --=-=
http://arcgraph.de/sr/
