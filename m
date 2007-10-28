Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbXJ1PXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbXJ1PXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 11:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbXJ1PXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 11:23:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50135 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXJ1PXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 11:23:46 -0400
Date: Sun, 28 Oct 2007 16:23:45 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Roel Kluin <12o3l@tiscali.nl>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Debugging activated during runtime
In-Reply-To: <4724A783.9050400@tiscali.nl>
Message-ID: <Pine.LNX.4.64.0710281618520.30465@fbirervta.pbzchgretzou.qr>
References: <4724A783.9050400@tiscali.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28 2007 16:15, Roel Kluin wrote:
>
>Wouldn't it be nice to be able to specify upon loading, or during runtime
>to modules whether debug messages should be printed?

modprobe ark3116 debug=1

Nothing new.

>- No kernel recompile needed for debugging.
>- Less *_DEBUG options required in menuconfig.
>
>How I think this could work:
>Add to the module struct a bool to denote debugging state. If set, pr_debug
>forwards messages to printk.
>
>Another advantage:
>- A module could be loaded after an unexpected conditions (e.g. after a BUG_ON).

After a BUG_ON, you are probably next to a panic.

>Caveats I can see right now:
>- For modules often loaded during boot this may not be a good solution.
>
>Alternatively, instead of a bool for the debug state, the module struct could
>also get a log-level flag: messages below that level won't be printed.

What problem are you trying to solve? YOu can pass the module
a parameter that can control how printk-verbose it will act. That is 
entirely in your hands, and it does not need to extend struct module.
