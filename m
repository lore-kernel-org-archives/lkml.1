Return-Path: <linux-kernel-owner+w=401wt.eu-S933620AbZJHVbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620AbZJHVbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932330AbZJHVbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:31:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38197 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932273AbZJHVbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:31:21 -0400
Date: Thu, 8 Oct 2009 22:32:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, gregkh@suse.de
Subject: Re: [Regression, bisected] Transmit failure in et131x.
Message-ID: <20091008223202.6e1b1303@lxorguk.ukuu.org.uk>
In-Reply-To: <20091008140805.GA21535@emergent.ellipticsemi.com>
References: <20091008140805.GA21535@emergent.ellipticsemi.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I bisected the problem to the following commit.  The WARN messages and
> bisection log are at the end of this email.
> 
> 356c74b401f6b05ae5d793e9d1a9ba8297b8e3ff is first bad commit
> commit 356c74b401f6b05ae5d793e9d1a9ba8297b8e3ff
> Author: Alan Cox <alan@linux.intel.com>
> Date:   Thu Aug 27 11:01:57 2009 +0100

Thanks. I'll go through that patch again see what I broke on your card.
Probably a wrapping bug with a long queue that my box for some reason
didn't manage to hit.

> Oct  5 23:37:53 aphrodite WARNING: at net/sched/sch_generic.c:261 dev_watchdog+0x13c/0x1fd()
> Oct  5 23:37:53 aphrodite Hardware name: System Product Name
> Oct  5 23:37:53 aphrodite NETDEV WATCHDOG: eth0 (et131x): transmit queue 0 timed out

That is the important bit. The rest is fall out from the fact the driver
doesn't recover properly when it fails.

Alan
