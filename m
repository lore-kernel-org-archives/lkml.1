Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbYHAIRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbYHAIRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 04:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYHAIQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 04:16:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbYHAIQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 04:16:52 -0400
Date: Fri, 1 Aug 2008 01:14:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jiri Slaby <jirislaby@gmail.com>, Dave Young <hidave.darkstar@gmail.com>,
       johannes@sipsolutions.net, tomasw@gmail.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, me@bobcopeland.com,
       linville@tuxdriver.com, stable@kernel.org
Subject: Re: [PATCH] ath5k : ath5k_config_interface deadlock fix
Message-Id: <20080801011415.ff4821a3.akpm@linux-foundation.org>
In-Reply-To: <4892C359.9000304@cs.helsinki.fi>
References: <20080801074014.GA3341@darkstar>
	<4892C2CA.7010003@gmail.com>
	<4892C359.9000304@cs.helsinki.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Aug 2008 11:03:37 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Jiri Slaby wrote:
> > Dave Young napsal(a):
> >> In the drivers/net/wireless/ath5k/base.c, there's recursive locking of 
> >> sc->lock
> >> This casue the kernel stuck
> >>
> >> Bug report please see:
> >> http://lkml.org/lkml/2008/7/29/32
> >>
> >> Fixed it by remove the lock in sub routine "ath5k_beacon_update",
> >> The ath5k_config_interface is the only caller to it.
> >>
> >> [  171.430207] =============================================
> >> [  171.432140] [ INFO: possible recursive locking detected ]
> >> [  171.433113] 2.6.27-rc1-smp #4
> >> [  171.434079] ---------------------------------------------
> >> [  171.435039] ath5k_pci/2447 is trying to acquire lock:
> >> [  171.435990]  (&sc->lock){--..}, at: [<f89ee9b5>] 
> >> ath5k_config_interface+0xd5/0x340 [ath5k]
> >> [  171.437046] [  171.437048] but task is already holding lock:
> >> [  171.438903]  (&sc->lock){--..}, at: [<f89ee91d>] 
> >> ath5k_config_interface+0x3d/0x340 [ath5k]
> >> [  171.439953] [  171.439954] other info that might help us debug this:
> >> [  171.441795] 3 locks held by ath5k_pci/2447:
> >> [  171.442729]  #0:  ((name)){--..}, at: [<c013a122>] 
> >> run_workqueue+0x102/0x1d0
> >> [  171.443800]  #1:  (&(&local->scan_work)->work){--..}, at: 
> >> [<c013a122>] run_workqueue+0x102/0x1d0
> >> [  171.444859]  #2:  (&sc->lock){--..}, at: [<f89ee91d>] 
> >> ath5k_config_interface+0x3d/0x340 [ath5k]
> > 
> > Should be fixed already:
> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commitdiff_plain;h=bc05116ab33d30342e2b4b1bcc6d6e1184e9df97 
> 
> I guess that didn't make it to -stable?

(cc stable!)
