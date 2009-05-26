Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbZEZSXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbZEZSXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbZEZSXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:23:23 -0400
Received: from bu3sch.de ([62.75.166.246]:60775 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891AbZEZSXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:23:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
Date: Tue, 26 May 2009 20:22:23 +0200
User-Agent: KMail/1.9.9
Cc: dave@thedillows.org, michael.riepe@googlemail.com, romieu@fr.zoreil.com,
       rsantos@grupopie.com, m.bueker@berlin.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <1242328457.32579.12.camel@lap75545.ornl.gov> <1243042174.3580.23.camel@obelisk.thedillows.org> <20090525.225503.173348268.davem@davemloft.net>
In-Reply-To: <20090525.225503.173348268.davem@davemloft.net>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905262022.24593.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009 07:55:03 David Miller wrote:
> From: David Dillow <dave@thedillows.org>
> Date: Fri, 22 May 2009 21:29:34 -0400
> 
> > The 8169 chip only generates MSI interrupts when all enabled event
> > sources are quiescent and one or more sources transition to active. If
> > not all of the active events are acknowledged, or a new event becomes
> > active while the existing ones are cleared in the handler, we will not
> > see a new interrupt.
> > 
> > The current interrupt handler masks off the Rx and Tx events once the
> > NAPI handler has been scheduled, which opens a race window in which we
> > can get another Rx or Tx event and never ACK'ing it, stopping all
> > activity until the link is reset (ifconfig down/up). Fix this by always
> > ACK'ing all event sources, and loop in the handler until we have all
> > sources quiescent.
> > 
> > Signed-off-by: David Dillow <dave@thedillows.org>
> 
> I've applied this, thanks David.
> 
> 

I didn't notice a CC:stable.
I think this should also go to stable.
Does somebody take care?

(wiggle is able to apply the patch to stable without any problems, so it's easy
to do a patch)

-- 
Greetings, Michael.
