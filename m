Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbZEMQAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbZEMQAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbZEMQAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:00:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754879AbZEMQAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:00:05 -0400
Date: Wed, 13 May 2009 08:57:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
Subject: Re: [PATCH v2 3/7] [PATCH 3/8] can: CAN Network device driver and
 Netlink interface
Message-Id: <20090513085734.387dddbe.akpm@linux-foundation.org>
In-Reply-To: <4A0AB0EC.5010902@grandegger.com>
References: <20090512092757.048938233@denx.de>
	<20090512092757.574693100@denx.de>
	<20090512233052.ecd600f1.akpm@linux-foundation.org>
	<20090512235323.e3de5e5d.akpm@linux-foundation.org>
	<4A0AB0EC.5010902@grandegger.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 13:37:16 +0200 Wolfgang Grandegger <wg@grandegger.com> wrote:

> > Also, I wonder if it's safe to take netif_tx_lock() from a timer
> > handler when other parts of the code might be taking it from process
> > context (I didn't check).
> > 
> > lockdep should be able to detect this, and I trust this code has been
> > fully runtime tested with lockdep enabled?
> 
> Well, CONFIG_PROVE_LOCKING would be cool, but I'm unable to enabled it
> for my MPC5200 test system. Only 64bit PowerPC's seem to support
> TRACE_IRQFLAGS_SUPPORT. I'm going to test the code on a PC as well.

I discussed this off-list with Peter Zijlstra and Johannes Berg. 
Apparently lockdep _will_ detect this deadlockable situation - Johannes
recently added the capability because he had the same situation in
wireless code somewhere.

But of course it does require that the timer handler has executed at
least once.  Many handlers in the kernel never fire in normal operation.

