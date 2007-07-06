Return-Path: <linux-kernel-owner+w=401wt.eu-S1762789AbXGFLHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762789AbXGFLHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 07:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759779AbXGFLHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 07:07:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:44942 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759656AbXGFLHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 07:07:43 -0400
To: Clemens Koller <clemens.koller@anagramm.de>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce panic_gently
References: <Pine.LNX.4.58.0707060034330.18989@be1.lrz>
	<468DF5D9.4040803@anagramm.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Jul 2007 14:03:05 +0200
In-Reply-To: <468DF5D9.4040803@anagramm.de>
Message-ID: <p73hcoh20zq.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Koller <clemens.koller@anagramm.de> writes:

> Bodo Eggert schrieb:
> > If the boot process failes to find init or the root fs, the cause
> > has usually scrolled off the screen, and because of the panic, it
> > can't be reached anymore.
> > This patch introduces panic_gently, which will allow to use the
> > scrollback buffer and to reboot, but it can't be called from unsafe
> > context.
> 
> In the case where you introduced panic_gently() there is IMHO no reason
> to panic() at all. There is no bug which got hit, the machine just needs
> user intervention because of wrong boot parameters (in most cases).
> 
> What about asking the user for the correct root= or init= parameters
> and just retry/continue the boot process?

BSDs have a boot shell for this. But not sure it's a good idea.
On EFI systems it might be better to just drop back to the boot environment
where a "re-boot" could be initiated.

> The 180seconds reboot timeout also doesn't make sense here. The problem
> won't go away after a reboot without user interaction.

It will when lilo -R/grubonce were used or the NFS server fixed itself
on nfs root or ... There can be many reasons for it being a good idea.

-Andi
