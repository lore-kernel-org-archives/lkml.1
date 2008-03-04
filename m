Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbYCDR2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbYCDR2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYCDR2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:28:01 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53299 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYCDR2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:28:00 -0500
Date: Tue, 4 Mar 2008 18:29:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-pm@lists.linux-foundation.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080304172918.GA27332@one.firstfloor.org>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com> <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org> <20080303231033.GB15255@one.firstfloor.org> <20080304040048.GA31562@codemonkey.org.uk> <20080304071423.0e6b71c1@mjolnir.drzeus.cx> <20080304181924.70aaf8c1@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304181924.70aaf8c1@mjolnir.drzeus.cx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So for now, I'm back to thinking that measuring the interval between deep sleeps is the better approach. I could use some ideas for a good clock source though. I haven't dug much deeper than jiffies when it comes to kernel timekeeping.

jiffies should work, you just need to make sure you measure them at the
right place. In particular there is some code in dyntick that catches
up on jiffies after the deep sleep when the normal timer handler didn't run
and jiffies are only usable again after that code executed.

-ANdi
