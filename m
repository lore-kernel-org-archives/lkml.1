Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYAUAIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYAUAIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 19:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbYAUAIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 19:08:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54346
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754993AbYAUAI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 19:08:28 -0500
Date: Sun, 20 Jan 2008 16:08:33 -0800 (PST)
Message-Id: <20080120.160833.166998420.davem@davemloft.net>
To: mingo@elte.hu
Cc: ak@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.24 regression: reference count leak in PPPoE
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080120200109.GA31876@elte.hu>
References: <200801202053.30386.ak@suse.de>
	<20080120200109.GA31876@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 20 Jan 2008 21:01:09 +0100

> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > My workstation running 2.6.24-rc8 just hung during shutdown with an 
> > endless (or rather I didn't wait more than a few minutes) loop of
> > 
> > unregister_netdev: waiting for ppp-device to become free. Usage count 
> > = 1
> > 
> > ppp-device was an active PPPoE device.
> > 
> > No more information currently.
> 
> i've seen such problems (locked up box with endless loop of usage count 
> == 1) with pppoe in the past, and it seemed to be related to dynamic 
> IPs. (i saw that well before 2.6.24 - reported it once to davem)

No, this is a different bug Andi is seeing and it was
recently introduced:

	http://bugzilla.kernel.org/show_bug.cgi?id=9778
