Return-Path: <linux-kernel-owner+w=401wt.eu-S1762033AbXHPHp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762033AbXHPHp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXHPHpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:45:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbXHPHpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:45:45 -0400
Message-ID: <46C4009F.9090206@redhat.com>
Date: Thu, 16 Aug 2007 09:45:35 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Robin Getz <rgetz@blackfin.uclinux.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Early printk behaviour
References: <200708152234.06734.rgetz@blackfin.uclinux.org>
In-Reply-To: <200708152234.06734.rgetz@blackfin.uclinux.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz wrote:
> I was putting together an early printk implementation for the Blackfin, and 
> was wondering what the expected behaviour was in this situation.
> 
> When I set up my bootargs earlyprintk=serial,ttyBF0,57600 and have no console 
> defined (no graphical console, no serial console).
> 
> based on the patch:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69331af79cf29e26d1231152a172a1a10c2df511
> 
> which no longer calls disable_early_printk, the earlyprintk console never gets 
> turned off (because nothing else ever calls register_console). I get 
> everything out the early console, until the init section is released (where 
> the console structure is sitting), and it starts printing out garbage.
> 
> Is this expected behaviour?

Hmm, sort of, although I didn't think about the case of no real console
replacing the early console.  The intention of the patch is to have a
smooth handover from the boot console to the real console.  And, yes, if
no real console is ever registered the boot console keeps running ...

So you can either let it running and *not* mark it __init, so it can
keep on going without breaking.  Or you can explicitly unregister your
boot console at some point, maybe using a late_initcall.

cheers,
  Gerd
