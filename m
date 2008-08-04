Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbYHDQiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbYHDQiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758101AbYHDQhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:37:45 -0400
Received: from mail.vyatta.com ([216.93.170.194]:42859 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758051AbYHDQho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:37:44 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.633
Date: Mon, 4 Aug 2008 09:37:42 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: greearb@candelatech.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC] netdev: debugging option
Message-ID: <20080804093742.395d271e@extreme>
In-Reply-To: <20080720.000509.20260185.davem@davemloft.net>
References: <20080719011709.GA5947@disturbed>
	<48821DEF.1040306@candelatech.com>
	<20080719230424.190957a3@extreme>
	<20080720.000509.20260185.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2008 00:05:09 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Sat, 19 Jul 2008 23:04:24 -0700
> 
> > This adds a debugging option for network devices. It could grow to add other
> > uses, but for now just add some messages about device reference counting.
> > 
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> I think this is useful but it could use some minor
> mods before we put it in.
> 
> For example, this thing will spam the logs in at least two
> common cases:
> 
> 1) Lots of routing cache replacements
> 
> 2) For older drivers using netif_rx() (and therefore, every
>    current tunnel), every RX packet will trigger a log message

Fixed by later patch.

> So we really need to add some kind of run time enable and also a
> filter of some sort, even if it's just on device.

The sysctl in the patch is default off, so unless it is turned on,
the log is quiet
