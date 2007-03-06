Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbXCFAZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbXCFAZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932809AbXCFAZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:25:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53529
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932794AbXCFAZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:25:53 -0500
Date: Mon, 05 Mar 2007 16:25:51 -0800 (PST)
Message-Id: <20070305.162551.41660347.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: andi@firstfloor.org, jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC] div64_64 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070305155714.3abe1b5e@freekitty>
References: <20070226143127.5c74bec9@freekitty>
	<p73slcnawh3.fsf@bingen.suse.de>
	<20070305155714.3abe1b5e@freekitty>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Mon, 5 Mar 2007 15:57:14 -0800

> I tried the code from Hacker's Delight.
> It is cool, but performance is CPU (and data) dependent:
> 
> Average # of usecs per operation:

Interesting results.

The problem with these algorithms that tradoff one or more
multiplies in order to avoid a divide is that they don't
give anything and often lose when both multiplies and
divides are emulated in software.

This is particularly true in this cube-root case from Hacker's
Delight, because it's using 3 multiplies per iteration in place of one
divide per iteration.

Actually, sorry, there is only one real multiply in there since the
other two can be computed using addition and shifts.

Another thing is that the non-Hacker's Delight version iterates
differently for different input values, so the input value space is
very important to consider when comparing these two pieces of code.
