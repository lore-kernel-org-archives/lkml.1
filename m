Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbXGAVaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbXGAVaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 17:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbXGAVaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 17:30:00 -0400
Received: from mx1.suse.de ([195.135.220.2]:60490 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbXGAV37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 17:29:59 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: blink driver power saving
Date: Sun, 1 Jul 2007 23:26:29 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20070701125035.3f54d8b0@oldman>
In-Reply-To: <20070701125035.3f54d8b0@oldman>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707012326.29974.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 July 2007 18:50:35 Stephen Hemminger wrote:
> The blink driver wakes up every jiffies which wastes power unnecessarily.
> Using a notifier gives same effect. Also add ability to unload module.

It's really a debugging tool where you normally don't care about
details like this. I wrote it to get visual feedback during kdump,
but it is nothing you should ever run during normal operation.

But I don't get how your patch is supposed to work. The blink driver
is not supposed to blink after panic -- panic does that anyways --
but always. So hooking it into the panic notifier chain which
is only called on panic makes about zero sense. 

If it's really needed to fix the wakeup issue the interface to
the keyboard blinking would need to be changed.

-Andi
