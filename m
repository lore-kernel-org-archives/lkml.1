Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZEZFzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZEZFzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 01:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZEZFzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 01:55:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59446
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbZEZFzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 01:55:04 -0400
Date: Mon, 25 May 2009 22:55:03 -0700 (PDT)
Message-Id: <20090525.225503.173348268.davem@davemloft.net>
To: dave@thedillows.org
Cc: michael.riepe@googlemail.com, mb@bu3sch.de, romieu@fr.zoreil.com,
       rsantos@grupopie.com, m.bueker@berlin.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
From: David Miller <davem@davemloft.net>
In-Reply-To: <1243042174.3580.23.camel@obelisk.thedillows.org>
References: <1242328457.32579.12.camel@lap75545.ornl.gov>
	<4A0C7443.1010000@googlemail.com>
	<1243042174.3580.23.camel@obelisk.thedillows.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Dillow <dave@thedillows.org>
Date: Fri, 22 May 2009 21:29:34 -0400

> The 8169 chip only generates MSI interrupts when all enabled event
> sources are quiescent and one or more sources transition to active. If
> not all of the active events are acknowledged, or a new event becomes
> active while the existing ones are cleared in the handler, we will not
> see a new interrupt.
> 
> The current interrupt handler masks off the Rx and Tx events once the
> NAPI handler has been scheduled, which opens a race window in which we
> can get another Rx or Tx event and never ACK'ing it, stopping all
> activity until the link is reset (ifconfig down/up). Fix this by always
> ACK'ing all event sources, and loop in the handler until we have all
> sources quiescent.
> 
> Signed-off-by: David Dillow <dave@thedillows.org>

I've applied this, thanks David.
