Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbYARNhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbYARNhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761500AbYARNhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:37:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48170
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761366AbYARNhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:37:11 -0500
Date: Fri, 18 Jan 2008 05:37:12 -0800 (PST)
Message-Id: <20080118.053712.195382841.davem@davemloft.net>
To: Robert.Olsson@data.slu.se
Cc: elendil@planet.nl, jesse.brandeburg@intel.com, slavon@bigtelecom.ru,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.24-rc7: e1000: Detected Tx Unit Hang
From: David Miller <davem@davemloft.net>
In-Reply-To: <18320.41737.651384.808195@robur.slu.se>
References: <18318.14810.877279.41815@robur.slu.se>
	<20080118.041144.81957249.davem@davemloft.net>
	<18320.41737.651384.808195@robur.slu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Olsson <Robert.Olsson@data.slu.se>
Date: Fri, 18 Jan 2008 14:00:57 +0100

>  I don't understand the idea with semaphore for enabling/disabling 
>  irq's either the overall logic must safer/better without it.  

They must have had code paths where they didn't know if IRQs were
enabled or not already, so they tried to create something which
approximates the:

	local_irq_save(flags);
	local_irq_restore(flags);

constructs we have for CPU interrupts, so they could go:

	e1000_irq_disable();
	/* ... */
	e1000_irq_enable();

and this would work even if the caller was running
with e1000 interrupts disabled already.

Or, something like that... it is indeed confusing.

Anyways, yes it's totally bogus and should be removed.
