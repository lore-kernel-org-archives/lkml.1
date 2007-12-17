Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbXLQRBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbXLQRBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbXLQRBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:01:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49246 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbXLQRBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:01:31 -0500
Date: Mon, 17 Dec 2007 09:00:00 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: "parag.warudkar@gmail.com" <parag.warudkar@gmail.com>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: init_timer_deferrable conversion
Message-ID: <20071217090000.64499fba@deepthought>
In-Reply-To: <20071217152943.10470215.dada1@cosmosbay.com>
References: <Pine.LNX.4.64.0712162149220.4622@mini.warudkars.net>
	<20071217095504.b02241ee.dada1@cosmosbay.com>
	<20071217152943.10470215.dada1@cosmosbay.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 15:29:43 +0100
Eric Dumazet <dada1@cosmosbay.com> wrote:

> On Mon, 17 Dec 2007 09:55:04 +0100
> Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > On Sun, 16 Dec 2007 22:00:23 -0500 (EST)
> > Parag Warudkar <parag.warudkar@gmail.com> wrote:
> > 
> > > In my quest to get the wake-ups from idle per second down to bare minimum, 
> > > I noticed 3 places in the kernel that could benefit from 
> > > using init_timer_deferrable() instead of init_timer() -
> > > 
> > > a) drivers/net/sky2.c - watchdog_timer. This was showing up high on 
> > > Powertop's list of things that cause routine wakeups from idle. After 
> > > converting to init_timer_deferrable() the wakeups went down and this one 
> > > no longer shows up in powertop's list. 25% reduction.

This surprises me because it is a 1 hz timer and uses round_jiffies() in
the current kernel.



-- 
Stephen Hemminger <shemminger@linux-foundation.org>
