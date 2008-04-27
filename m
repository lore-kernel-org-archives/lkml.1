Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbYD0W6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbYD0W6q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYD0W6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:58:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37797
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbYD0W6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:58:34 -0400
Date: Sun, 27 Apr 2008 15:58:34 -0700 (PDT)
Message-Id: <20080427.155834.189904598.davem@davemloft.net>
To: hpa@zytor.com
Cc: jeff@garzik.org, James.Bottomley@HansenPartnership.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
From: David Miller <davem@davemloft.net>
In-Reply-To: <48150392.6040508@zytor.com>
References: <4815009C.2010809@garzik.org>
	<20080427.154620.177583216.davem@davemloft.net>
	<48150392.6040508@zytor.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 27 Apr 2008 15:52:02 -0700

> Arguably, the right thing is to not even have ioremap() anymore, just 
> ioremap_{cache,nocache,wc} and consider any unconverted ioremap() as a 
> flag to audit that particular piece of code.
> 
> I don't think that can be done "instantly", though, so defaulting 
> ioremap() to uncached (as it apparently has been on other arches 
> already?) is the conservative option in the meantime.

I think this is a reasonable course of action.

That leaves one of Jeff's concerns, what to do with pci_iomap().  That
was designed to give mappings with caching enabled, and as a result we
probably should make it behave that way.
